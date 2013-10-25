#encoding: utf-8 
class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :media_requests, :media_request_type_id
    add_index :media_requests, :sender_id
    add_index :media_requests, :employment_search_id
    add_index :trend_questions, :employment_search_id
    add_index :discussions, :employment_search_id
    add_index :holiday_conversations, :recipient_id
    add_index :holiday_conversations, :holiday_id
    add_index :media_request_discussions, :media_request_id
    add_index :media_request_discussions, :restaurant_id
    add_index :assets, [:id, :type]
    add_index :direct_messages, :in_reply_to_message_id
    add_index :holiday_discussions, :restaurant_id
    add_index :holiday_discussions, :holiday_id
    add_index :events, :restaurant_id
    add_index :holiday_discussion_reminders, :holiday_discussion_id
    add_index :holiday_discussion_reminders, :holiday_reminder_id
    add_index :holidays, :employment_search_id
    add_index :users, :james_beard_region_id
    add_index :admin_discussions, :restaurant_id
    add_index :admin_discussions, [:discussionable_id, :discussionable_type], :name => 'admin_discussions_by_discussionable'
    add_index :content_requests, :employment_search_id
  end

  def self.down
    remove_index :media_requests, :media_request_type_id
    remove_index :media_requests, :sender_id
    remove_index :media_requests, :employment_search_id
    remove_index :trend_questions, :employment_search_id
    remove_index :discussions, :employment_search_id
    remove_index :holiday_conversations, :recipient_id
    remove_index :holiday_conversations, :holiday_id
    remove_index :media_request_discussions, :media_request_id
    remove_index :media_request_discussions, :restaurant_id
    remove_index :assets, :column => [:id, :type]
    remove_index :direct_messages, :in_reply_to_message_id
    remove_index :holiday_discussions, :restaurant_id
    remove_index :holiday_discussions, :holiday_id
    remove_index :events, :restaurant_id
    remove_index :holiday_discussion_reminders, :holiday_discussion_id
    remove_index :holiday_discussion_reminders, :holiday_reminder_id
    remove_index :holidays, :employment_search_id
    remove_index :users, :james_beard_region_id
    remove_index :admin_discussions, :restaurant_id
    remove_index :admin_discussions, :name => 'admin_discussions_by_discussionable'
    remove_index :content_requests, :employment_search_id
  end
end
