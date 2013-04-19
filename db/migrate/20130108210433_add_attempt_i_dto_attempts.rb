class AddAttemptIDtoAttempts < ActiveRecord::Migration
  def up
    add_column :csv_errors,:attempt_id,:integer
  end

  def down
  end
end