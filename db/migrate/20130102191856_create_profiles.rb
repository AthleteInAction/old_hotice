class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :source
      t.string :destination
      t.column :status,:enum,:limit => ['new','opened','closed'],default: 'new'
      t.boolean :active,default: 1

      t.timestamps
    end
  end
end