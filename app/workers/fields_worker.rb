class FieldsWorker
  
  include Sidekiq::Worker
  require 'gentools'
  require 'zendeskAPI'
  require 'rinoThread'
  require 'csv'
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
    
    zd = ZendeskAPI.new(domain: client.subdomain,username: client.username,password: client.password)
    JP %{Getting ticket fields...\n}
    fields = zd.getCall('/api/v2/ticket_fields.json')
    
    JP %{Destroying previous fields...\n}
    CustomFields.where("client_id = #{client.id}").destroy_all

    system_field_types = ['subject','description','status','tickettype','priority','group','assignee']
    
    z = 0
    list = []
    fields[:body]['ticket_fields'].each do |f|
      if !system_field_types.include? f['type']

        final = {
          id: f['id'],
          profile_id: params['profile_id'],
          client_id: client.id,
          display_name: f['title'].strip,
          field_type: f['type'],
          required: f['required'],
          solve: f['required_in_portal'],
          rel: z
        }
        z += 1
        if f['custom_field_options']

          final = final.merge(field_options: '')

          options = []
          f['custom_field_options'].each do |option|

            options << option['value']

          end
          final[:field_options] << options.join(',')

        end
        
        list << final
        JP %{Custom Field: #{f['title']}\n}

      end        
    end
    
    JP %{Saving fields...\n}
    CustomFields.create(list)
    JP %{Finished!\n}
    
  end
  
end