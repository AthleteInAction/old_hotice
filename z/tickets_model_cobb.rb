class TicketValidator < ActiveModel::Validator
  
  require 'date'
  
  def validate ticket
    
    time_1 = ticket.created_at.to_s
    time_2 = time_1.split('/')
    time_3 = time_2[0].to_s+'-'+time_2[1].to_s+'-20'+time_2[2].to_s
    time_4 = Date.strptime(time_3,'%m-%d-%Y')
    #JP %{\n\n:::::: [][][][] #{time_4}\n\n}
    time_5 = DateTime.parse(time_4.to_s).iso8601.gsub('+00:00','Z')
    ticket.created_at = time_5
    ticket.status = 'closed'
    
    
    sql = Mysql2::Client.new(
      :host => 'localhost',
      :username => 'root',
      :database => 'migrationrocket_v2'
    )
    
    tags = ticket.tags.to_s.split(',')
    tags << ticket.old_id
    ticket.tags = tags.join(',')
    ticket.description = %{#{ticket.description}\n\n#{ticket.cf_5}}
    if (ticket.description == '' && ticket.cf_5 == '') || (!ticket.description && !ticket.cf_5)
      
      ticket.decription = "Imported incident ##{ticket.old_id}"
      
    end
    if !ticket.cf_1 || ticket.cf_1 == ''
      ticket.cf_1 = 'other'
    end
    if !ticket.cf_7 || ticket.cf_7 == ''
      ticket.cf_7 = '-'
    end
    
    if ticket.assignee_email && ticket.assignee_email != ''
      
      #user = ZdUsers.where(email: ticket.assignee_email,profile_id: ticket.profile_id)
      user = []
      q = "SELECT * FROM zd_users WHERE profile_id = #{ticket.profile_id} AND email = '#{sql.escape(ticket.assignee_email)}' LIMIT 1"
      sql.query(q).each do |row|
        user << row
      end
      if user.count > 0
        ticket.assignee_id = user.first['zendesk_id']
      else
        ticket.assignee_id = 232600273
        #ticket.errors[:base] << "Assignee not found: #{ticket.assignee_email}"
      end
      
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
        #ticket.assignee_id = 333416813
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
        ticket.requester_id = 232600273
        #ticket.errors[:base] << "Requester not found: #{ticket.requester_email}"
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
  
  attr_accessible :assignee_email, :assignee_id, :code, :description, :due_at, :error, :external_id, :file_id, :group_id, :group_name, :old_id, :organization_id, :organization_name, :priority, :profile_id, :report, :requester_email, :requester_id, :state, :status, :subject, :submitter_email, :submitter_id, :tags, :t_type, :zendesk_id,:cf_0,:cf_1,:cf_2,:cf_3,:cf_4,:cf_5,:cf_6,:cf_7,:cf_8,:cf_9,:cf_10,:cf_11,:cf_12,:cf_13,:cf_14,:cf_15,:cf_16,:cf_17,:cf_18,:cf_19,:created_at, :pulled
  
  validates_with TicketValidator
  #validates_presence_of :description,:requester_email
  
  def self.to_csv params
    
    CSV.generate do |csv|
      remove = ['id','profile_id','file_id','pulled','zendesk_id','active','error','old_id','created_at','updated_at','state']
      20.times do |i|
        remove << "cf_#{i}"
      end
      remove.each do |r|
        column_names.delete(r)
      end
      final = ['file']
      final.concat column_names
      #column_names.unshift('file')
      puts JSON.pretty_generate column_names
      csv << final
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