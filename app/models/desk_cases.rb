class DeskCases < ActiveRecord::Base
  attr_accessible :case_status_type, :customer_id, :description, :desk_id, :group_id, :group_name, :import_status, :labels, :priority, :subject, :user_id, :user_name, :zendesk_id, :created_at
end