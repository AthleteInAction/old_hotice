class ChangeAttachmentDefault < ActiveRecord::Migration
  def up
    change_column_default :attachments,:complete,0
    change_column_default :attachments,:total,0
  end

  def down
  end
end