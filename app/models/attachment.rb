class Attachment < ActiveRecord::Base
  attr_accessible :active, :complete, :file, :locked, :open, :profile_id, :state, :status, :total
  validates_presence_of :file
  mount_uploader :file,FileUploader
end