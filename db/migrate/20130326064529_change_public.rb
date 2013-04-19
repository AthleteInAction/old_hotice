class ChangePublic < ActiveRecord::Migration
  def up
    change_column :ticket_comments,:public,:string
  end

  def down
  end
end