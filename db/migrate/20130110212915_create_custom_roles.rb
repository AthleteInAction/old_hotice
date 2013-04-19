class CreateCustomRoles < ActiveRecord::Migration
  def change
    create_table :custom_roles do |t|
      t.integer :profile_id
      t.integer :client_id
      t.string :name

      t.timestamps
    end
  end
end
