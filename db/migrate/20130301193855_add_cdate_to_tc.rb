class AddCdateToTc < ActiveRecord::Migration
  def change
    add_column :ticket_comments,:cdate,:string
    add_column :tickets,:cdate,:string
  end
end