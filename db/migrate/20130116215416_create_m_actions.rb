class CreateMActions < ActiveRecord::Migration
  def change
    create_table :m_actions do |t|
      t.integer :profile_id
      t.integer :map_id
      t.integer :field_id
      t.string :field_val

      t.timestamps
    end
  end
end
