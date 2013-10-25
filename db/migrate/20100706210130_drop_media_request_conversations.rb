#encoding: utf-8 
class DropMediaRequestConversations < ActiveRecord::Migration
  def self.up
    drop_table :media_request_conversations
  end

  def self.down
    create_table "media_request_conversations", :force => true do |t|
      t.integer  "media_request_id"
      t.integer  "recipient_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "comments_count",   :default => 0
    end
  end
end
