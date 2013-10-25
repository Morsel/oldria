#encoding: utf-8 
class ChangeDirectMessagesBodyToText < ActiveRecord::Migration
  def self.up
    change_column :direct_messages, :body, :text, :limit => nil
  end

  def self.down
    change_column :direct_messages, :body, :string
  end
end
