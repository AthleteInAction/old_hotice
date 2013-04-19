class CustomRoles < ActiveRecord::Base
  attr_accessible :id, :client_id, :name, :profile_id
end