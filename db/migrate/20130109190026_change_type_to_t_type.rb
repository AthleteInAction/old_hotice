class ChangeTypeToTType < ActiveRecord::Migration
  def up
    rename_column :tickets,:type,:t_type
  end

  def down
  end
end