class Profile < ActiveRecord::Base
  attr_accessible :active, :description, :destination, :name, :source, :status, :user_id, :state, :locked, :action, :organizations, :users, :groups, :step, :synced
  validates_presence_of :name,:source,:destination
end