class AddSyncedToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles,:synced,:boolean,default: 0
  end
end