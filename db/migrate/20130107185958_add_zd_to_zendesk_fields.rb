class AddZdToZendeskFields < ActiveRecord::Migration
  def change
    add_column :zendesk_fields,:zendesk,:boolean,default: 1
  end
end