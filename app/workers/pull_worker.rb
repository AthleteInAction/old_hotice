class PullWorker
  
  include Sidekiq::Worker
  require 'gentools'
  require 'zendeskAPI'
  require 'rinoThread'
  require 'csv'
  require 'mysql2'
  sidekiq_options retry: false
  def GetModel type
    
    ntype = type.capitalize
    
    if type.to_s.downcase == 'users'
      ntype = 'ZdUsers'
    end
    if type.to_s.downcase == 'ticket_comments'
      ntype = 'TicketComments'
    end
    
    ntype.constantize
    
  end
  
  def perform params
    
    profile = Profile.find(params['profile_id'])
    client = Client.find(profile['destination'])
    
    zendesk = ZendeskAPI.new(
      domain: client['subdomain'],
      username: client['username'],
      password: client['password']
    )
    
    profile.update_attributes(locked: 1,action: 'syncing',status: 'running')
    
    if profile.organizations
      params['type'] = 'organizations'
      PullRecords zendesk,params,client,profile
    end
    if profile.users
      params['type'] = 'users'
      PullRecords zendesk,params,client,profile
    end
    if profile.groups
      params['type'] = 'groups'
      PullRecords zendesk,params,client,profile
    end
    
    profile.update_attributes(locked: 0,action: nil,status: 'opened')
    
  end
  
  def PullRecords zendesk,params,client,profile
    
    JP %{\nRemoving previously pulled records...\n}
    profile.update_attributes(action: "Clearing previous #{params['type']}",status: 'running')
    GetModel(params['type']).where("pulled = 1 AND profile_id = #{params['profile_id']}").destroy_all
    
    JP %{Pulling #{params['type']}...\n}
    profile.update_attributes(action: "Gathering #{params['type']}",status: 'running')
    
    page_call = zendesk.getCall("/api/v2/#{params['type']}.json")
    pages = (page_call[:body]['count'].to_f/100.to_f).ceil
    zd_fields = ZendeskField.where("active = 1 AND zendesk = 1 AND state = '#{params['type']}'")
    
    list = []
    @rate = []
    @limit = 15
    tasks = RinoThread.new(@limit)
    pages.times do |i|
      tasks.queue do
        1.times do
          
          a = Time.now.to_f
          
          call = zendesk.getCall("/api/v2/#{params['type']}.json?page=#{(i+1)}")
          call[:body][params['type']].each_with_index do |c,z|
            
            record = {
              profile_id: params['profile_id'],
              zendesk_id: c['id'],
              state: 'imported',
              pulled: 1,
              code: 201
            }
            
            zd_fields.each do |f|
              
              key = f['db_name']
              val = c[f['db_name']]
              val = val.join(',') if key == 'tags'
              val.to_s.strip! if key.include? 'email'
              
              
              
              record = record.merge(key => val)
              
            end
            
            list << record
            
          end
          
          b = Time.now.to_f
          c = b.to_f-a.to_f
          
          @rate << Time.now.to_f
          if @rate.count > 1
            
            elapsed = @rate.last.to_f-@rate.first.to_f
            total = @rate.count
            rate = ((60.to_f/elapsed.to_f)*total.to_f).round
            #JP %{#{total} / #{elapsed} ::: Rate: #{rate}/min\n}
            
          end
          out = "API Call ##{(i+1)} ::: #{c}"
          out << " || Rate: #{rate}/min" if @rate.count > 1 && elapsed >= 1
          JP %{#{out}\n}
          
        end
      end
    end
    
    tasks.execute
    
    JP %{Creating freshly pulled records...}
    profile.update_attributes(action: "Saving #{params['type']}",status: 'running')
    GetModel(params['type']).create(list)
    JP %{Finished!}
    
  end
  
  
end