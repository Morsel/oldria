# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  title            :string(50)      default("")
#  comment          :text
#  commentable_id   :integer
#  commentable_type :string(255)
#  user_id          :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  acts_as_readable
  has_many :attachments, :as => :attachable, :class_name => '::Attachment', :dependent => :destroy
  belongs_to :commentable, :polymorphic => true, :counter_cache => true
  belongs_to :user
  default_scope :order => "#{table_name}.created_at ASC"


  accepts_nested_attributes_for :attachments

  scope :not_user, lambda { |user| {
    :conditions => ["user_id != ?", user.id]
  }}

  scope :from_premium_users, {
    :joins => { :user => :subscription },
    :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
      Date.today]
  }

  attr_accessible :user_id, :comment,:user,:attachments_attributes,:title,:commentable_id,:commentable_type
  #validates_presence_of :comment

  attr_accessor :post_to_facebook

  before_create :clear_read_status

  def clear_read_status
    if self.commentable.respond_to?(:action_required?)
      self.commentable.readings.each { |r| r.destroy }
    end
  end

  ##
  # This is only meant to be called as a callback from the observer
  def notify_recipients
    # Only models that already have notifications set up
    # With special exception for HolidayDiscussion because the notification is on HolidayDiscussionReminder
    return unless commentable.respond_to?(:notify_recipients) || commentable.is_a?(HolidayDiscussion)
    return if commentable.is_a?(SoloDiscussion) # no other recipients to notify

    # Which method of finding users? (using the first available method)
    users_method = %w(employees users).detect {|method| commentable.respond_to?(method)}
    return unless users_method

    commentable.send(users_method).each do |recipient|
      if (user_id != recipient.id) && recipient.prefers_receive_email_notifications
        UserMailer.message_comment_notification(commentable, recipient, user).deliver
      end
    end
  end

  def restaurant
    if commentable.respond_to?(:restaurant)
      commentable.restaurant
    else
      user.employments.present? && user.primary_employment.restaurant
    end
  end

  def employment
    return nil unless user
    @employment ||= if restaurant
      user.employments.find_by_restaurant_id(restaurant.id)
    else
      user.primary_employment
    end
  end

  def self.on_resource_by_user(resource, user)
    return [] unless resource && user
    self.all(:conditions => ['commentable_type = ? AND commentable_id = ? AND user_id = ?', resource.class.to_s, resource.id, user.id])
  end

  def editable?
    commentable.is_a?(Admin::Conversation) ||
        (commentable.is_a?(AdminDiscussion) && commentable.discussionable.is_a?(TrendQuestion)) ||
        commentable.is_a?(SoloDiscussion)
  end

  def editable_by?(person)
    return false unless editable?
    (self.user == person) || self.user.coworkers.include?(person) || person.admin?
  end

  # find all soapbox published qotds comments containing the keyboard
  def self.search_qotd_comments(keyword, page = nil)
    select_params = { :select => 'comments.id as comment_id,
               comments.comment as comment_comment,
               comments.updated_at as comment_at,
               comments.user_id as comment_user_id,
               admin_messages.display_message as question_display_message,
               admin_messages.message as question_short_message' }

    Admin::Qotd.search(:admin_conversations_comments_comment_like=>keyword).
      all(select_params)
  end

  # find all soapbox published trend questions comments containing the keyboard
  def self.search_trend_question_comments(keyword, page = nil)
    select_params = { :select => 'comments.id as comment_id,
               comments.comment as comment_comment,
               comments.updated_at as comment_at,
               comments.user_id as comment_user_id,
               trend_questions.display_message as question_display_message,
               trend_questions.subject as question_short_message' }

    d_comments = TrendQuestion.search(:admin_discussions_comments_comment_like=>keyword).
      all(select_params)

    d_comments + TrendQuestion.search(:solo_discussions_comments_comment_like=>keyword).
      all(select_params)
  end

  def commentable_title
    if commentable.respond_to?(:admin_message)
      commentable.admin_message.try(:message)
    elsif commentable.respond_to?(:discussionable)
      commentable.discussionable.try(:subject)
    end
  end

  def activity_name
    "comment on \"#{commentable_title}\""
  end

  def track_activity?
    if commentable.is_a?(Admin::Conversation) || commentable.is_a?(AdminDiscussion) || commentable.is_a?(SoloDiscussion)
      true
    else
      false
    end
  end

end
