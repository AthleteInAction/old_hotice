class CustomFields < ActiveRecord::Base
  attr_accessible :id, :display_name, :field_options, :field_type, :profile_id, :required, :rel, :client_id, :solve
  validates_uniqueness_of :id
end