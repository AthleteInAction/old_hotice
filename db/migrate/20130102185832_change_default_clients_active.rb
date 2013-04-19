class ChangeDefaultClientsActive < ActiveRecord::Migration
  def up
    change_column_default :clients,:active,1
  end

  def down
  end
end