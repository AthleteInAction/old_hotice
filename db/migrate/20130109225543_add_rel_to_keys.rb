class AddRelToKeys < ActiveRecord::Migration
  def change
    add_column :custom_fields,:rel,:integer
  end
end