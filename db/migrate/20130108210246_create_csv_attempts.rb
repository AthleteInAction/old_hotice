class CreateCsvAttempts < ActiveRecord::Migration
  def change
    create_table :csv_attempts do |t|
      t.integer :profile_id
      t.integer :file_id

      t.timestamps
    end
  end
end
