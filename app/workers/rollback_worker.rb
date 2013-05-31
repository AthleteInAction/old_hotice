class RollbackWorker
  
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
  
  
  # Perform
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def perform params
    
    @profile = Profile.find(params['profile_id'])
    @client = Client.find(@profile['destination'])
    
    @zendesk = ZendeskAPI.new(
      domain: @client['subdomain'],
      username: @client['username'],
      password: @client['password']
    )
    
    list = []
    #types = ['organizations','users','groups','tickets']
    types = ['organizations','users']
    types.each_with_index do |type,i|
      
      GetModel(type).where(pulled: 0,profile_id: @profile.id,state: 'imported').order('id ASC').each do |item|
        
        list << {type: type,id: item.zendesk_id}
        
      end
      
    end
    
    JP %{List: #{list.count}\n}
    
    @rate = []
    @limit = 7
    threads = RinoThread.new(@limit)
    list.each_with_index do |item,i|
      threads.queue do
        
        a = Time.now.to_f
        
        sql = Mysql2::Client.new(:host => 'localhost',:username => 'root',:database => 'migrationrocket_v2')
        
        table = item[:type]
        table = 'zd_users' if item[:type] == 'users'
        call = @zendesk.deleteCall("/api/v2/#{item[:type]}/#{item[:id]}.json")
        if call[:code].to_f.round == 200
          
          q = "UPDATE #{table} SET state = 'deleted' WHERE zendesk_id = '#{item[:id]}'"
          sql.query q
          #out << %{#{q}\n}
          
        else
          
          JP %{Item ##{item[:id]} not deleted!\n}
          #out << %{#{table} => #{item[:id]} failed!}
          
        end
        
        sql.close
        
        b = Time.now.to_f
        c = b.to_f-a.to_f
        
        @rate << Time.now.to_f
        if @rate.count > 1
          
          elapsed = @rate.last.to_f-@rate.first.to_f
          total = @rate.count
          rate = ((60.to_f/elapsed.to_f)*total.to_f).round
          #JP %{#{total} / #{elapsed} ::: Rate: #{rate}/min\n}
          
        end
        out = "API Call ##{(i+1)} |#{call[:code]}| ::: #{c}"
        out << " || Rate: #{rate}/min" if @rate.count > 1 && elapsed >= 1
        JP %{#{out}\n}
        
      end
      
      #break if i >= 100
      
    end
    
    threads.execute
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
end