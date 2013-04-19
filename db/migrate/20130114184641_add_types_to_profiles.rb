class AddTypesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles,:organizations,:boolean,default: 1
    add_column :profiles,:users,:boolean,default: 1
    add_column :profiles,:groups,:boolean,default: 1
  end
end