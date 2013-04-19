class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :attachment_id
      t.string :header
      t.string :field_name
      t.integer :field_id
      t.boolean :custom_field,default: 0
      t.boolean :active,default: 1

      t.timestamps
    end
  end
end