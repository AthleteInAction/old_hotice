class ChangeDefault < ActiveRecord::Migration
  def up
    change_column :profiles,:step,:integer,default: 2
  end

  def down
  end
end