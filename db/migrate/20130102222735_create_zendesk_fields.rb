class CreateZendeskFields < ActiveRecord::Migration
  def change
    create_table :zendesk_fields do |t|
      t.column :state,:enum,:limit => ['organizations','users','groups','group_memberships','ticketcomments','tickets'],:default => 'organizations'
      t.string :db_name
      t.string :display_name
      t.boolean :required,default: 0
      t.boolean :active,default: 1

      t.timestamps
    end
  end
end