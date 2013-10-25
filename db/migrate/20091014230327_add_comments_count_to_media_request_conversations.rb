#encoding: utf-8 
class AddCommentsCountToMediaRequestConversations < ActiveRecord::Migration
  def self.up
    add_column :media_request_conversations, :comments_count, :integer, :default => 0

    MediaRequestConversation.reset_column_information
    MediaRequestConversation.find(:all).each do |m|
      MediaRequestConversation.update_counters m.id, :comments_count => m.comments.length
    end
  end

  def self.down
    remove_column :media_request_conversations, :comments_count
  end
end
