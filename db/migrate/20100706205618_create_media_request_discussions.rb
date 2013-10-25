#encoding: utf-8 
class CreateMediaRequestDiscussions < ActiveRecord::Migration
  def self.up
    create_table :media_request_discussions do |t|
      t.integer :media_request_id
      t.integer :restaurant_id
      t.integer :comments_count

      t.timestamps
    end
  end

  def self.down
    drop_table :media_request_discussions
  end
end
