class ImportAttempts < ActiveRecord::Base
  attr_accessible :active, :profile_id, :state
end