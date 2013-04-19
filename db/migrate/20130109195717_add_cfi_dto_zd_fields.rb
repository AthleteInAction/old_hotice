class AddCfiDtoZdFields < ActiveRecord::Migration
  def up
    add_column :zendesk_fields,:custom_field,:boolean,default: 0
    add_column :zendesk_fields,:custom_field_id,:integer
  end

  def down
  end
end