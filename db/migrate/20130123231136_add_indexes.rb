class AddIndexes < ActiveRecord::Migration
  def up
    add_index :organizations,:profile_id
    add_index :organizations,:name
    add_index :groups,:profile_id
    add_index :groups,:name
    add_index :zd_users,:profile_id
    add_index :zd_users,:email
    add_index :csv_errors,:profile_id
  end

  def down
  end
end