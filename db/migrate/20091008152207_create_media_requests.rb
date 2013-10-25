#encoding: utf-8 
class CreateMediaRequests < ActiveRecord::Migration
  def self.up
    create_table :media_requests do |t|
      t.integer :sender_id
      t.text :message
      t.timestamps
    end
  end
  
  def self.down
    drop_table :media_requests
  end
end
