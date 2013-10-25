#encoding: utf-8 
class AddAdminAttributeToDirectMessages < ActiveRecord::Migration
  def self.up
    add_column :direct_messages, :from_admin, :boolean, :default => false
  end

  def self.down
    remove_column :direct_messages, :from_admin
  end
end
