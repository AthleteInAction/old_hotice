class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :profile_id
      t.string :m_type
      t.string :data_type
      t.integer :field_1
      t.string :val_1
      t.integer :field_2
      t.string :val_2

      t.timestamps
    end
  end
end
