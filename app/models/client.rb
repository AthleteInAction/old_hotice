class Client < ActiveRecord::Base
  attr_accessible :active, :code, :name, :password, :subdomain, :user_id, :username
  validates_presence_of :name,:subdomain,:username,:password
end
