class AddCFsToTypes2 < ActiveRecord::Migration
  def change
    20.times do |i|
      
      add_column :zd_users,'cf_'+i.to_s,:text
      
    end
  end
end