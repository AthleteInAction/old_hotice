class UserValidator < ActiveModel::Validator
  def validate user
    
    user.email = user.email.to_s.strip.downcase
    
    # AdMarvel
    if user.profile_id == 34
      puts %{\n#{user.email}}
      user.name = user.email
      user.role = 'end-user'
    end
    
    user.active = 1 if user.active.to_s.downcase == 'true'
    user.active = 0 if user.active.to_s.downcase == 'false'
    
    if user.pulled
      
      if user.email.is_a? String
        user.email = user.email.gsub('.fake.zd','')
      end
      
    else
      
      if user.custom_role_name && user.custom_role_name!=''

        role = CustomRoles.where(name: user.custom_role_name.to_s.downcase,profile_id: user.profile_id)
        if role.count > 0
          user.custom_role_id = role.first.id
        else
          user.errors[:base] << "Custom role not found!"
        end

      end

      if user.organization_name && user.organization_name != ''

        org = Organizations.where(name: user.organization_name,profile_id: user.profile_id)
        if org.count > 0
          user.organization_id = org.first.zendesk_id
        else
          user.errors[:base] << "Organization not found!"
        end

      end
      
    end
    
  end
end


class ZdUsers < ActiveRecord::Base
  
  attr_accessible :active, :alias, :code, :custom_role_id, :custom_role_name, :details, :email, :error, :external_id, :file_id, :identities, :locale_id, :moderator, :name, :notes, :old_id, :only_private_comments, :organization_id, :organization_name, :phone, :profile_id, :report, :role, :signature, :state, :suspended, :tags, :ticket_restriction, :time_zone, :verified, :zendesk_id, :pulled
  
  validates_with UserValidator
  validates_presence_of :email,:name,:role,:if => :not_pulled?
  validates_uniqueness_of :email,scope: :profile_id,:if => :not_pulled?

  def not_pulled?
    !pulled
  end
  
  def self.to_csv
    
    CSV.generate do |csv|
      remove = ['profile_id','file_id','pulled','zendesk_id','active','error','old_id','created_at','updated_at','state']
      remove.each do |r|
        column_names.delete(r)
      end
      puts JSON.pretty_generate column_names
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
    
  end
  
end