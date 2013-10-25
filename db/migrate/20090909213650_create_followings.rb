#encoding: utf-8 
class CreateFollowings < ActiveRecord::Migration
  def self.up
    create_table :followings do |t|
      t.integer :follower_id
      t.integer :friend_id
      t.timestamps
    end
  end
  
  def self.down
    drop_table :followings
  end
end
