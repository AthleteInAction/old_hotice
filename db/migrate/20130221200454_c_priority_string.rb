class CPriorityString < ActiveRecord::Migration
  def up
    change_column :tickets,:priority,:string
  end

  def down
  end
end