# == Schema Information
# Schema version: 20120217190417
#
# Table name: quick_replies
#
#  message_id   :string
#  message_type :string
#  reply_text   :text
#  user_id      :integer
#

class QuickReply < ActiveRecord::Base
  attr_protected
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :message_id, :string
  column :message_type, :string
  column :reply_text, :text
  column :user_id, :integer

  validates_presence_of :reply_text, :message_id, :message_type, :user_id
  validates_length_of :reply_text, :maximum => 2000

  belongs_to :message, :polymorphic => true
  belongs_to :user

  attr_accessor :restaurant_ids
  validates_presence_of :restaurant_ids

  def save
    # This is where the action is!
    return false unless valid?

    discussions.each do |discussion|
      discussion.comments.create(:comment => reply_text, :user_id => user_id)
    end

    # debugging_info
    true
  end

  def discussions
    return [] unless restaurant_ids
    @discussions ||= restaurant_ids.map do |restaurant_id|
      message.admin_discussions.find_by_restaurant_id(restaurant_id)
    end.compact
  end

  private

  def debugging_info
    Rails.logger.info <<-EOT

    discussions = #{discussions.join(' ')}
    user = #{user.name}
    message = #{message_type} #{message_id}

    EOT
  end

end
