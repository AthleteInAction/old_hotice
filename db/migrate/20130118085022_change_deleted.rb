class ChangeDeleted < ActiveRecord::Migration
  def up
    change_column :profiles,:status,:enum,limit: ['new','opened','running','completed','deleted'],default: 'new'
  end

  def down
  end
end