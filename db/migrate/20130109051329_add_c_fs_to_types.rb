class AddCFsToTypes < ActiveRecord::Migration
  def change
    20.times do |i|
      
      add_column :organizations,'cf_'+i.to_s,:text
      
    end
  end
end