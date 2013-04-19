class AddStepToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles,:step,:integer,default: 1
  end
end