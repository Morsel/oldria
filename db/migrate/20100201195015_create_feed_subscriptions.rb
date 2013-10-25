#encoding: utf-8 
class CreateFeedSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :feed_subscriptions do |t|
      t.integer :user_id
      t.integer :feed_id

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_subscriptions
  end
end
