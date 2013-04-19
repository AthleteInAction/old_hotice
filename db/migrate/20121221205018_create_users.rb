class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      
      t.string :name
      t.string :email
      t.string :password_digest
      t.column :role,:enum,limit: ['admin','agent','end-user'],default: 'admin'

      t.timestamps
      
    end
  end
end