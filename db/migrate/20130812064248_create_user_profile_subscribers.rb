#encoding: utf-8 
class CreateUserProfileSubscribers < ActiveRecord::Migration
  def self.up
    create_table :user_profile_subscribers do |t|
      t.integer :profile_subscriber_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_profile_subscribers
  end
end
