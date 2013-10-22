# == Schema Information
#
# Table name: trend_questions
#
#  id                   :integer         not null, primary key
#  subject              :string(255)
#  body                 :text
#  scheduled_at         :datetime
#  expired_at           :datetime
#  created_at           :datetime
#  updated_at           :datetime
#  employment_search_id :integer
#  display_message      :string(255)
#  slug                 :string(255)
#

class TrendQuestion < ActiveRecord::Base
  acts_as_readable
  belongs_to :employment_search

  has_many :admin_discussions, :as => :discussionable, :dependent => :destroy
  has_many :restaurants, :through => :admin_discussions
  
  has_many :solo_discussions, :dependent => :destroy
  has_many :employments, :through => :solo_discussions

  has_one :soapbox_entry, :as => :featured_item, :dependent => :destroy

  validates_presence_of :subject, :body
  validates_length_of :slug, :maximum => 30, :allow_nil => true

  scope :by_scheduled_date, :order => "#{table_name}.scheduled_at desc"
  scope :by_subject, :order => "#{table_name}.subject asc"

  scope :current, :conditions => ['scheduled_at < ? OR scheduled_at IS NULL', Time.zone.now]

  before_save :update_restaurants_and_employments_from_search_criteria
  
  def self.title
    "What's New"
  end

  def inbox_title
    self.class.title
  end

  def mailer_method
    'answerable_message_notification'
  end

  def message
    [subject, body].compact.join(': ')
  end

  def update_restaurants_and_employments_from_search_criteria
    self.restaurant_ids = employment_search.restaurant_ids
    self.employments = employment_search.solo_employments
  end

  def viewable_by?(employment)
    return false unless employment
    employment.employee == employment.restaurant.try(:manager) ||
    employment.omniscient? ||
    employment_search.employments.relation.include?(employment)
  end

  def discussions
    admin_discussions + solo_discussions
  end

  def discussions_with_replies
    admin_discussions.with_replies + solo_discussions.with_replies
  end

  def discussions_without_replies
    admin_discussions.without_replies + solo_discussions.without_replies
  end

  def reply_count
    admin_discussions.with_replies.count + solo_discussions.with_replies.count
  end

  def comments_count
    admin_discussions.sum(:comments_count) + solo_discussions.sum(:comments_count)
  end

  def self.on_soapbox_with_response_from_user(user = nil)
    return [] unless user
    if user.restaurants.present?
      self.all(:joins => [:soapbox_entry, { :admin_discussions => :comments }], 
               :conditions => ['comments.user_id = ?', user.id], 
               :group => 'trend_questions.id',
               :limit => 5)
    else
      self.all(:joins => [:soapbox_entry, { :solo_discussions => :comments }], 
               :conditions => ['comments.user_id = ?', user.id], 
               :group => 'trend_questions.id',
               :limit => 5)
    end
  end

  def comments(deep_includes = false)
    includes = deep_includes ? { :user => :employments } : nil
    Comment.scoped(:conditions => ["(commentable_id IN (?) AND commentable_type = 'AdminDiscussion') OR
      (commentable_id IN (?) AND commentable_type = 'SoloDiscussion')",
      admin_discussions.with_replies.all(:select => "id").map { |d| d.id },
      solo_discussions.with_replies.all(:select => "id").map { |d| d.id }],
      :include => includes, :group => 'comments.id')
  end

  def last_comment
    Comment.scoped(:conditions => ["(commentable_id IN (?) AND commentable_type = 'AdminDiscussion') OR
      (commentable_id IN (?) AND commentable_type = 'SoloDiscussion')",
      admin_discussions.with_replies.all(:select => "id").map { |d| d.id },
      solo_discussions.with_replies.all(:select => "id").map { |d| d.id }],
      :order => "comments.created_at DESC",
      :limit => 1).first
  end

  def title
    self.class.title
  end
  
  def recipients_can_reply?
    true
  end
  
  def soapbox_comment_count
    discussions_with_replies.count
  end

end
