class ChangeCFsToClientId < ActiveRecord::Migration
  def up
    add_column :custom_fields,:client_id,:integer
  end

  def down
  end
end