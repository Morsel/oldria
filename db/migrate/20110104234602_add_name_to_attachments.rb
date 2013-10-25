#encoding: utf-8 
class AddNameToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :name, :string
  end

  def self.down
    remove_column :attachments, :name
  end
end
