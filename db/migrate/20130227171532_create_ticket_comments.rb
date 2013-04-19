class CreateTicketComments < ActiveRecord::Migration
  def change
    create_table :ticket_comments do |t|
      t.integer :profile_id
      t.integer :file_id
      t.string :ticket_id
      t.string :ticket_comment_id
      t.integer :zendesk_id
      t.integer :old_id
      t.string :author_email
      t.integer :author_id
      t.text :value
      t.boolean :public
      t.boolean :active

      t.timestamps
    end
  end
end
