class CreateDeskCases < ActiveRecord::Migration
  def change
    create_table :desk_cases do |t|
      t.integer :zendesk_id
      t.integer :desk_id
      t.integer :priority
      t.string :subject
      t.integer :group_id
      t.string :group_name
      t.integer :user_id
      t.string :user_name
      t.text :description
      t.integer :customer_id
      t.string :case_status_type
      t.text :labels
      t.string :import_status

      t.timestamps
    end
  end
end
