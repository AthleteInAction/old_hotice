class CreateImportAttempts < ActiveRecord::Migration
  def change
    create_table :import_attempts do |t|
      t.integer :profile_id
      t.column :state,:enum,:limit => ['organizations','users','groups','group_memberships','ticketcomments','tickets']
      t.boolean :active,default: 1

      t.timestamps
    end
  end
end