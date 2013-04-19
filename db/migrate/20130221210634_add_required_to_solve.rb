class AddRequiredToSolve < ActiveRecord::Migration
  def change
    add_column :custom_fields,:solve,:boolean,default: 0
  end
end