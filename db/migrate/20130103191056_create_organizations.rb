class CreateOrganizations < ActiveRecord::Migration
  def change
    
    create_table :organizations do |t|
      
      t.integer :profile_id
      t.integer :file_id
      t.integer :zendesk_id
      t.string :old_id
      t.string :external_id
      t.string :name
      t.text :domain_name
      t.text :details
      t.text :notes
      t.boolean :shared_tickets
      t.boolean :shared_comments
      t.text :tags
      t.boolean :active,default: 1
      t.column :status,:enum,:limit => [:pending,:imported,:deleted],default: :pending
      t.boolean :error,default: 0
      t.text :report
      t.integer :code

      t.timestamps
      
    end
  end
end
