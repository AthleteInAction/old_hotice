class CreateCsvErrors < ActiveRecord::Migration
  def change
    create_table :csv_errors do |t|
      t.integer :file_id
      t.text :data
      t.integer :row

      t.timestamps
    end
  end
end
