class TicketValidator < ActiveModel::Validator
  
  require 'date'
  
  def validate ticket
    
    #ticket.cf_0 = 'prophix_for_sql_server_5_1_24_0' if ticket.cf_0 == 'prophix_for_sql_server__5_1_24_0'
    
    sql = Mysql2::Client.new(
      :host => 'localhost',
      :username => 'root',
      :database => 'migrationrocket_v2'
    )
    
    
    
    # Tagger Validation
    # [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    fields = CustomFields.where(profile_id: ticket.profile_id)
    fields.each do |f|
      
      val = ticket["cf_#{f['rel']}"]
      
      if f['field_type'] == 'tagger'
        
        options = f['field_options'].split(',')

        if val && val != ''

          if options.include?(val)



          else

            ticket.errors[:base] << "CF: #{f['display_name']} |#{val}| must match one of the following: #{f['field_options']}"

          end

        end
        
      end
      
      if f['required'] && ticket.status.to_s.downcase == 'solved'
        
        if !val || val == ''
          ticket.errors[:base] << "CF: #{f['display_name']} is required to solve this ticket"
        end
        
      end
      
    end
    # [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
    
    if ticket.cdate && ticket.cdate != ''# && 1==2
      
      ticket.cdate = DateTime.strptime("#{ticket.cdate} -07:00",'%m/%d/%Y %H:%M:%S %z').to_s
      #ticket.cdate = DateTime.parse("#{ticket.cdate} -07:00").iso8601.to_s
      #ticket.cdate = DateTime.strptime("#{ticket.cdate} -07:00",'%m/%d/%Y %H:%M %z')
      
    else
      #ticket.cdate = comment.created_at
    end
    
    
    pri = ['','low','normal','high','urgent']
    #puts %{#{ticket.priority} || [][][][][][][][][][][][]\n}
    
    if pri.include?(ticket.priority.to_s.downcase)
      #ticket.priority = pri.index(ticket.priority.to_s.downcase)
    else
      #ticket.errors[:base] << "Priority |#{ticket.priority}| must match one of the following: #{pri.join(',')}"
    end
    
    
    
    if ticket.assignee_email && ticket.assignee_email != ''
      
      #user = ZdUsers.where(email: ticket.assignee_email,profile_id: ticket.profile_id)
      user = []
      q = "SELECT * FROM zd_users WHERE profile_id = #{ticket.profile_id} AND email = '#{sql.escape(ticket.assignee_email)}' LIMIT 1"
      sql.query(q).each do |row|
        user << row
      end
      if user.count > 0
        
         if user.first['zendesk_id'] && user.first['zendesk_id'] != ''
           if user.first['role'] == 'agent' || user.first['role'] == 'admin'
             ticket.assignee_id = user.first['zendesk_id']
           else
             ticket.errors[:base] << "Assignee must be an agent: #{ticket.assignee_email}"
           end
         else
           ticket.errors[:base] << "Assignee not found: #{ticket.assignee_email}"
         end
         
      else
        #ticket.assignee_id = 301048188# Craig Willis || Host Analytics
        ticket.errors[:base] << "Assignee not found: #{ticket.assignee_email}"
      end
      
    end
    
    if (!ticket.assignee_id || ticket.assignee_id == '') && ticket.status == 'solved'
      
      ticket.errors[:base] << "Assignee {#{ticket.assignee_email}} is required to solve this ticket"
      
    end
    
    if ticket.submitter_email && ticket.submitter_email != ''
      
      user = []
      q = "SELECT * FROM zd_users WHERE profile_id = #{ticket.profile_id} AND email = '#{sql.escape(ticket.submitter_email)}' LIMIT 1"
      sql.query(q).each do |row|
        user << row
      end
      if user.count > 0
        ticket.submitter_id = user.first['zendesk_id']
      else
        #ticket.submitter_id = 301048188# Craig Willis || Host Analytics || Sand: 345472007
        ticket.errors[:base] << "Submitter not found: #{ticket.submitter_email}"
      end
      
    end
    
    if ticket.requester_email && ticket.requester_email != ''
      
      user = []
      q = "SELECT * FROM zd_users WHERE profile_id = #{ticket.profile_id} AND email = '#{sql.escape(ticket.requester_email)}' LIMIT 1"
      sql.query(q).each do |row|
        user << row
      end
      if user.count > 0
        ticket.requester_id = user.first['zendesk_id']
      else
        #ticket.requester_id = 301048188# Craig Willis || Host Analytics
        ticket.errors[:base] << "Requester not found: #{ticket.requester_email}"
      end
      
    end
    
    if ticket.organization_name && ticket.organization_name != ''
      
      org = []
      q = "SELECT * FROM organizations WHERE profile_id = #{ticket.profile_id} AND name = '#{sql.escape(ticket.organization_name)}' LIMIT 1"
      sql.query(q).each do |row|
        org << row
      end
      if org.count > 0
        ticket.organization_id = org.first['zendesk_id']
      else
        ticket.errors[:base] << "Organization not found: #{sql.escape(ticket.organization_name)}"
      end
      
    end
    
    sql.close
    
  end
end


class Tickets < ActiveRecord::Base
  
  attr_accessible :assignee_email, :assignee_id, :code, :description, :due_at, :error, :external_id, :file_id, :group_id, :group_name, :old_id, :organization_id, :organization_name, :priority, :profile_id, :report, :requester_email, :requester_id, :state, :status, :subject, :submitter_email, :submitter_id, :tags, :t_type, :zendesk_id,:cf_0,:cf_1,:cf_2,:cf_3,:cf_4,:cf_5,:cf_6,:cf_7,:cf_8,:cf_9,:cf_10,:cf_11,:cf_12,:cf_13,:cf_14,:cf_15,:cf_16,:cf_17,:cf_18,:cf_19,:created_at, :pulled, :cdate
  
  validates_with TicketValidator
  validates_presence_of :description,:requester_email
  
  def self.to_csv params
    
    cf = CustomFields.where(profile_id: params['profile_id'])
    cfs = []
    rel = {}
    cf.each do |f|
      cfs << "cf_"+f['rel'].to_s
      rel = rel.merge("cf_"+f['rel'].to_s => f['display_name'])
    end
    
    CSV.generate do |csv|
      remove = ['id','profile_id','file_id','pulled','zendesk_id','active','error','old_id','created_at','updated_at','state']
      20.times do |i|
        remove << "cf_#{i}" if !cfs.include?("cf_"+i.to_s)
      end
      remove.each do |r|
        column_names.delete(r)
      end
      
      #puts JSON.pretty_generate column_names
      
      final = ['file']
      final.concat column_names
      
      final_data = []
      final.each do |f|
        
        if cfs.include? f
          final_data << rel[f]
        else
          final_data << f
        end
        
      end
      
      csv << final_data
      all.each do |item|
        
        item['file'] = 'file not found'
        if item['file_id']
          
          attach = Attachment.find(item['file_id'])
          if attach
            item['file'] = attach.file.url.split('/').last
          end
          
        end
        
        csv << item.attributes.values_at(*final)
      end
    end
    
  end
  
end