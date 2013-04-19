class AddProfileIDtoCsvErrors < ActiveRecord::Migration
  def up
    add_column :csv_errors,:profile_id,:integer
  end

  def down
  end
end