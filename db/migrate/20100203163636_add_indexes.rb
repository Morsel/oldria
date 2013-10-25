#encoding: utf-8 
class AddIndexes < ActiveRecord::Migration
  def self.up
    # These were generated using the rails_indexes plugin
    add_index :feeds, :id, :unique => true
    add_index :date_ranges, :id, :unique => true
    add_index :discussions, :id, :unique => true
    add_index :restaurants, :id, :unique => true
    add_index :users, :id, :unique => true
    add_index :pages, :slug
    add_index :employments, :restaurant_role_id
    add_index :employments, :restaurant_id
    add_index :employments, :employee_id
    add_index :coached_status_updates, :date_range_id
    add_index :feed_subscriptions, :user_id
    add_index :feed_subscriptions, :feed_id
    add_index :discussions, :poster_id
    add_index :restaurants, :cuisine_id
    add_index :restaurants, :james_beard_region_id
    add_index :restaurants, :metropolitan_area_id
    add_index :restaurants, :manager_id
    add_index :discussion_seats, :user_id
    add_index :discussion_seats, :discussion_id
    add_index :responsibilities, :employment_id
    add_index :responsibilities, :subject_matter_id
    add_index :direct_messages, :receiver_id
    add_index :direct_messages, :sender_id
    add_index :statuses, :user_id
    add_index :media_request_conversations, :recipient_id
    add_index :media_request_conversations, :media_request_id
    add_index :feed_entries, :feed_id
    add_index :followings, :friend_id
    add_index :followings, :follower_id
    add_index :users, :email
    add_index :users, :username
    add_index :attachments, [:attachable_id, :attachable_type]
  end

  def self.down
    remove_index :users, :id
    remove_index :date_ranges, :id
    remove_index :discussions, :id
    remove_index :restaurants, :id
    remove_index :feeds, :id
    remove_index :pages, :slug
    remove_index :employments, :restaurant_role_id
    remove_index :employments, :restaurant_id
    remove_index :employments, :employee_id
    remove_index :coached_status_updates, :date_range_id
    remove_index :feed_subscriptions, :user_id
    remove_index :feed_subscriptions, :feed_id
    remove_index :discussions, :poster_id
    remove_index :restaurants, :cuisine_id
    remove_index :restaurants, :james_beard_region_id
    remove_index :restaurants, :metropolitan_area_id
    remove_index :restaurants, :manager_id
    remove_index :discussion_seats, :user_id
    remove_index :discussion_seats, :discussion_id
    remove_index :responsibilities, :employment_id
    remove_index :responsibilities, :subject_matter_id
    remove_index :direct_messages, :receiver_id
    remove_index :direct_messages, :sender_id
    remove_index :statuses, :user_id
    remove_index :media_request_conversations, :recipient_id
    remove_index :media_request_conversations, :media_request_id
    remove_index :feed_entries, :feed_id
    remove_index :followings, :friend_id
    remove_index :followings, :follower_id
    remove_index :users, :email
    remove_index :users, :username
    remove_index :attachments, :column => [:attachable_id, :attachable_type]
  end
end
