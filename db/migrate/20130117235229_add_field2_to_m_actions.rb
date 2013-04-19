class AddField2ToMActions < ActiveRecord::Migration
  def change
    
    add_column :m_actions,:field_2_id,:integer
    add_column :m_actions,:atype,:string
    
  end
end