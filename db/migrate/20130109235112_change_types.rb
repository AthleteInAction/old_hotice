class ChangeTypes < ActiveRecord::Migration
  def up
    rename_column :zd_users,:status,:state
    rename_column :organizations,:status,:state
  end

  def down
  end
end