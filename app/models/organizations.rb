class OrgValidator < ActiveModel::Validator
  
  def validate org
    
    org.name = org.name.to_s.strip
    
  end
  
end


class Organizations < ActiveRecord::Base
  
  attr_accessible :active, :code, :details, :domain_name, :error, :external_id, :file_id, :name, :notes, :old_id, :profile_id, :report, :shared_comments, :shared_tickets, :state, :tags, :zendesk_id, :pulled
  validates_with OrgValidator
  validates_uniqueness_of :name,scope: :profile_id,if: :not_pulled?
  validates_presence_of :name,if: :not_pulled?
  
  def not_pulled?
    !pulled
  end
  
  
  def self.to_csv
    
    CSV.generate do |csv|
      remove = ['id','profile_id','file_id','pulled','zendesk_id','active','error','old_id','created_at','updated_at','state']
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