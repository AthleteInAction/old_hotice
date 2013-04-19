class AddActiveToMaps < ActiveRecord::Migration
  def change
    add_column :maps,:active,:boolean,default: 1
  end
end