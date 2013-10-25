#encoding: utf-8 
class CreateDirectMessages < ActiveRecord::Migration
  def self.up
    create_table :direct_messages do |t|
      t.string :title
      t.string :body
      t.integer :sender_id, :null => false
      t.integer :receiver_id, :null => false
      t.integer :in_reply_to_message_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :direct_messages
  end
end
