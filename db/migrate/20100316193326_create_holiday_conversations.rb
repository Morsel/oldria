#encoding: utf-8 
class CreateHolidayConversations < ActiveRecord::Migration
  def self.up
    create_table :holiday_conversations do |t|
      t.integer :recipient_id
      t.integer :holiday_id
      t.integer :comments_count, :default => 0, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_conversations
  end
end
