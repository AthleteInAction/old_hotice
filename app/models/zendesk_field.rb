class ZendeskField < ActiveRecord::Base
  attr_accessible :active, :db_name, :display_name, :required, :state, :zendesk,:custom_field,:custom_field_id
end
