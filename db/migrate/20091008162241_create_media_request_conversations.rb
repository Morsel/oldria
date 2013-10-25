#encoding: utf-8 
class CreateMediaRequestConversations < ActiveRecord::Migration
  def self.up
    create_table :media_request_conversations do |t|
      t.integer :media_request_id
      t.integer :recipient_id

      t.timestamps
    end
  end

  def self.down
    drop_table :media_request_conversations
  end
end
