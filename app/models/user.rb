class User < ActiveRecord::Base
  
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation, :role
  validates_presence_of :email,:name
  validates_uniqueness_of :email
  
end