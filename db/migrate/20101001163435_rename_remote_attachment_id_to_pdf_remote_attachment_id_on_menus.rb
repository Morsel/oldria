#encoding: utf-8 
class RenameRemoteAttachmentIdToPdfRemoteAttachmentIdOnMenus < ActiveRecord::Migration
  def self.up
    rename_column :menus, :remote_attachment_id, :pdf_remote_attachment_id
  end

  def self.down
    rename_column :menus, :pdf_remote_attachment_id, :remote_attachment_id
  end
end
