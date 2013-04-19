class RemoveAttachments < ActiveRecord::Migration
  def up
    drop_table :attachments
  end

  def down
  end
end