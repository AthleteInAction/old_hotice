class AddCFsToTypesRemove < ActiveRecord::Migration
  def change
    20.times do |i|
      
      remove_column :zd_users,'cf_'+i.to_s
      remove_column :organizations,'cf_'+i.to_s
      
    end
  end
end