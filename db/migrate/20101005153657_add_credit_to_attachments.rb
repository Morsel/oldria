#encoding: utf-8 
class AddCreditToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :credit, :string
  end

  def self.down
    remove_column :attachments, :credit
  end
end
