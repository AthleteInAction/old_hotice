class CommentValidator < ActiveModel::Validator
  
  require 'date'  
  
  def validate comment
    
    sql = Mysql2::Client.new(
      :host => 'localhost',
      :username => 'root',
      :database => 'migrationrocket_v2'
    )
    
    if comment.cdate && comment.cdate != ''# && 1==2
      
      comment.cdate = DateTime.strptime("#{comment.cdate} -07:00",'%m/%d/%Y %H:%M:%S %z').to_s
      #comment.cdate = DateTime.parse("#{comment.cdate} -07:00").iso8601.to_s
      #ticket.cdate = DateTime.strptime("#{ticket.cdate} -07:00",'%m/%d/%Y %H:%M %z')
      
    else
      #ticket.cdate = comment.created_at
    end
    
    if ['true','yes','1'].include?(comment['public'].to_s.downcase)
      comment['public'] = 'true'
    else
      comment['public'] = 'false'
    end
    
    ZendeskField.where(state: 'ticket_comments').each do |f|
      
      if f.required && (!comment[f.db_name.to_s] || comment[f.db_name.to_s].strip == '')
        comment.errors[:base] << "#{f.display_name} is required"
      end
      
    end
    
    author = ZdUsers.where(profile_id: comment.profile_id,email: comment.author_email).limit(1).first
    if author
      comment.author_id = author.zendesk_id
    else
      #q = "UPDATE tickets SET code = 999,error = 1 WHERE old_id = '#{comment.ticket_id}' AND profile_id = #{comment.profile_id}"
      #sql.query q
      #comment.errors[:base] << "Author >>>#{comment.author_email}<<< cannot be found!"
      comment.old_id = 1
      comment.author_id = 345472007# Craig Willis
    end
    
    sql.close
    
  end
  
end

class TicketComments < ActiveRecord::Base
  
  attr_accessible :active, :author_email, :author_id, :file_id, :old_id, :profile_id, :public, :ticket_comment_id, :ticket_id, :value, :zendesk_id, :created_at, :cdate
  
  validates_with CommentValidator
  
end