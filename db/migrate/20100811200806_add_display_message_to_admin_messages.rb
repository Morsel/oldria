#encoding: utf-8 
class AddDisplayMessageToAdminMessages < ActiveRecord::Migration
  def self.up
    add_column :admin_messages, :display_message, :string
  end

  def self.down
    remove_column :admin_messages, :display_message
  end
end
