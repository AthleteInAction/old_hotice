class ChangeErrorsToAlerts < ActiveRecord::Migration
  def up
    rename_column :csv_errors,:errors,:alerts
  end

  def down
  end
end