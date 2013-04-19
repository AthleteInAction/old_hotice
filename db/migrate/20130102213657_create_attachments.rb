class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :profile_id
      t.column :state,:enum,:limit => ['organizations','users','groups','group_memberships','ticketcomments','tickets'],:default => 'organizations'
      t.string :file
      t.boolean :open,:default => 1
      t.column :status,:enum,:limit => ['ready','extracting','complete','error'],:default => 'ready'
      t.integer :complete
      t.integer :total
      t.boolean :active,:default => 1
      t.boolean :locked,:default => 0

      t.timestamps
    end
  end
end