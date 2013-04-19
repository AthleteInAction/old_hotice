class CreateConditions < ActiveRecord::Migration
  def change
    create_table :conditions do |t|
      t.integer :profile_id
      t.integer :map_id
      t.integer :field_id
      t.string :condition
      t.string :field_value

      t.timestamps
    end
  end
end
