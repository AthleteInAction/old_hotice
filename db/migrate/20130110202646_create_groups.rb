class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      
      t.integer :profile_id
      t.integer :file_id
      t.integer :zendesk_id
      t.string :old_id
      t.string :name
      t.column :state,:enum,limit: ['pending','imported','deleted'],default: 'pending'
      t.boolean :error,default: 0
      t.text :report
      t.integer :code

      t.timestamps
      
    end
  end
end