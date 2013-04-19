class AddActionToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles,:action,:string
    add_column :profiles,:locked,:boolean,default: 0
  end
end