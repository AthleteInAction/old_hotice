class CsvWorker
  
  include Sidekiq::Worker
  require 'gentools'
  require 'csv'
  require 'json'
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
  
  def perform params,attempt
    
    profile = Profile.find(params['profile_id'])
    attachment = Attachment.find(params['attachment_id'])
    attachment.update_attributes(locked: 1,status: 'extracting')
    keys = Keys.where("active = 1 AND attachment_id = #{params['attachment_id']}")
    
    zd_fields = {}
    ZendeskField.where("state = '#{params['type']}' AND active = 1").each do |zd|
      zd_fields = zd_fields.merge(zd['id'].to_s => zd['db_name'])
    end
    cf_fields = {}
    CustomFields.where("client_id = #{profile['destination']}").each do |cf|
      
      cf_fields = cf_fields.merge(cf['id'] => 'cf_'+cf['rel'].to_f.round.to_s)
      
    end
    
    JP %{\n}
    
    i = 0
    CSV.foreach(attachment.file.url,:encoding => 'iso-8859-1',:headers => true) do |row|
      
      item = {
        'profile_id' => params['profile_id'],
        'file_id' => params['attachment_id']
      }
      
      keys.each do |f|
        
        db_name = zd_fields[f['field_id'].to_s].to_s
        db_name = 't_type' if db_name == 'type'
        
        if f['custom_field']
          
          db_name = cf_fields[f['field_id']]
          
        end
        
        val = row[f['header'].to_s]
        if (db_name == 'requester_email' || db_name == 'assignee_email') && params['type'] == 'tickets'
          #val = 'ian@cobbtuning.com' if val.to_s == ''
        end
        item = item.merge(db_name => val)
        
      end
      
      newItem = GetModel(params['type']).new(item)
      if newItem.save
        
        
        
      else
        
        errors = newItem.errors.full_messages.to_s.gsub('"','')
        item = item.merge(errors: errors)
        #JP errors
        CsvErrors.new(profile_id: params['profile_id'],attempt_id: attempt,alerts: errors,file_id: attachment['id'],row: (i+2)).save
        
      end
      
      i += 1
      
      print "\rRow: #{i}                   "
      
      attachment.update_attributes(complete: i)
      
    end
    
    attachment.update_attributes(locked: 1,status: 'complete')
    #jkljlkj.ds.fa.dsf.s.f.d.a.ds--a=09823
    
  end
  
end