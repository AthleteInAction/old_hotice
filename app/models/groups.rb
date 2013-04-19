class Groups < ActiveRecord::Base
  attr_accessible :code, :error, :file_id, :name, :old_id, :profile_id, :report, :state, :zendesk_id, :pulled
  validates_presence_of :name
  validates_uniqueness_of :name,scope: :profile_id
  
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