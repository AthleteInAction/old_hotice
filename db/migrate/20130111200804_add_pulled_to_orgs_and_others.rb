class AddPulledToOrgsAndOthers < ActiveRecord::Migration
  def change
    add_column :organizations,:pulled,:boolean,default: 0
    add_column :zd_users,:pulled,:boolean,default: 0
    add_column :groups,:pulled,:boolean,default: 0
    add_column :tickets,:pulled,:boolean,default: 0
  end
end