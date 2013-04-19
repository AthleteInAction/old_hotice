class AddProfileIDtoKeys < ActiveRecord::Migration
  def up
    add_column :keys,:profile_id,:integer
  end

  def down
  end
end