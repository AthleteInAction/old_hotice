class CreateCustomFields < ActiveRecord::Migration
  def change
    create_table :custom_fields do |t|
      t.integer :profile_id
      t.integer :custom_field_id
      t.string :display_name
      t.boolean :required,default: 0
      t.text :field_type
      t.text :field_options

      t.timestamps
    end
  end
end