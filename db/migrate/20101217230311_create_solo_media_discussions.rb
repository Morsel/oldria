#encoding: utf-8 
class CreateSoloMediaDiscussions < ActiveRecord::Migration
  def self.up
    create_table :solo_media_discussions do |t|
      t.integer :media_request_id
      t.integer :employment_id
      t.integer :comments_count

      t.timestamps
    end
  end

  def self.down
    drop_table :solo_media_discussions
  end
end
