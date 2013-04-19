class ChangePriority < ActiveRecord::Migration
  def up
    change_column :tickets,:priority,:integer
  end

  def down
  end
end