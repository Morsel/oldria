#encoding: utf-8 
class AddAcceptedToHolidayConversations < ActiveRecord::Migration
  def self.up
    add_column :holiday_conversations, :accepted, :boolean
  end

  def self.down
    remove_column :holiday_conversations, :accepted
  end
end
