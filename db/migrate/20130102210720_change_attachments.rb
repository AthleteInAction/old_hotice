class ChangeAttachments < ActiveRecord::Migration
  def up
    change_column_default :attachments,:active,1
    change_column_default :attachments,:locked,0
    change_column :attachments,:status,:enum,:limit => ['ready','extracting','complete','error'],:default => 'ready'
    change_column :attachments,:state,:enum,:limit => ['organizations','users','groups','group_memberships','ticketcomments','tickets'],:default => 'organizations'
  end

  def down
  end
end