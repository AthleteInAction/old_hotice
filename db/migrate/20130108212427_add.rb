class Add < ActiveRecord::Migration
  def up
    add_column :csv_errors,:errors,:text
  end

  def down
  end
end