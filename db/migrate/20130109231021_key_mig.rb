class KeyMig < ActiveRecord::Migration
  def up
    add_column :keys,:rel,:integer
    remove_column :keys,:custom_field_id
    remove_column :keys,:field_name
  end

  def down
  end
end