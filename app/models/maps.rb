class Maps < ActiveRecord::Base
  attr_accessible :name, :data_type, :field_1, :field_2, :m_type, :profile_id, :val_1, :val_2, :active
  validates_presence_of :profile_id,:name,:data_type
end
