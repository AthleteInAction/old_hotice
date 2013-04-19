class RemoveCustomFieldIdFromCustomFields < ActiveRecord::Migration
  def up
    remove_column :custom_fields,:custom_field_id
  end

  def down
  end
end