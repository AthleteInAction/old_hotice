class CreateZdUsers < ActiveRecord::Migration
  def change
    create_table :zd_users do |t|
      t.integer :profile_id
      t.integer :file_id
      t.integer :zendesk_id
      t.string :old_id
      t.string :external_id
      t.string :name
      t.string :alias
      t.boolean :active,default: 1
      t.boolean :verified,default: 1
      t.string :locale_id
      t.string :time_zone
      t.string :email
      t.string :phone
      t.text :identities
      t.text :signature
      t.text :details
      t.text :notes
      t.string :organization_name
      t.integer :organization_id
      t.column :role,:enum,limit: ['end-user','admin','agent'],default: 'end-user'
      t.string :custom_role_name
      t.integer :custom_role_id
      t.boolean :moderator
      t.column :ticket_restriction,:enum,limit: [:organization,:groups,:assigned,:requested]
      t.boolean :only_private_comments
      t.text :tags
      t.boolean :suspended
      t.column :status,:enum,limit: [:pending,:imported,:deleted],default: :pending
      t.boolean :error,default: 0
      t.text :report
      t.integer :code

      t.timestamps
    end
  end
end
