class AddStateToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles,:state,:enum,:limit => ['organizations','users','groups','group_memberships','ticketcomments','tickets'],:default => 'organizations'
  end
end