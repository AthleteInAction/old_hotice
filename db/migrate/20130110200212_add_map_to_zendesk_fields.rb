class AddMapToZendeskFields < ActiveRecord::Migration
  def change
    add_column :zendesk_fields,:map,:boolean,default: 1
  end
end