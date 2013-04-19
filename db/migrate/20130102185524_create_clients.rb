class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :code
      t.string :name
      t.string :username
      t.string :password
      t.string :subdomain
      t.integer :user_id
      t.boolean :active

      t.timestamps
    end
  end
end
