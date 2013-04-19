class AddCfiDtoKeys < ActiveRecord::Migration
  def up
    add_column :keys,:custom_field_id,:integer
  end

  def down
  end
end