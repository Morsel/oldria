# == Schema Information
# Schema version: 20120217190417
#
# Table name: chapters
#
#  id          :integer         not null, primary key
#  topic_id    :integer
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer         default(0)
#  description :string(255)
#

class Chapter < ActiveRecord::Base

  belongs_to :topic
  has_many :profile_questions
  has_many :restaurant_questions
  has_many :trace_keywords, :as => :keywordable

  validates_presence_of :title, :topic_id
  validates_uniqueness_of :title, :scope => :topic_id, :case_sensitive => false
  validates_length_of :description, :maximum => 100

  default_scope :include => :topic, :order => "chapters.position ASC"
  attr_accessible :title,:description,:topic_id


  scope :for_user, lambda { |user|
    { :joins => { :profile_questions => :question_roles },
      :conditions => ["question_roles.restaurant_role_id = ?", user.primary_employment.restaurant_role.id],
      :group => "chapters.id",
      :order => "chapters.position" }
  }

  scope :for_restaurant, lambda { |restaurant|
    { :joins => :topic,
      :conditions => ["topics.type = 'RestaurantTopic'"],
      :group => "chapters.id",
      :order => "chapters.position" }
  }

  scope :for_page, lambda { |page|
    { :joins => { :restaurant_questions => :question_pages },
      :conditions => ["question_pages.restaurant_feature_page_id = ?", page.id],
      :group => "chapters.id",
      :order => "chapters.position" }
  }

  scope :answered_for_user, lambda { |user|
    { :joins => { :profile_questions => :profile_answers },
      :conditions => ["profile_answers.user_id = ?", user.id],
      :group => "chapters.id",
      :order => "chapters.position" }
  }

  scope :answered_for_restaurant, lambda { |restaurant|
    { :joins => { :restaurant_questions => :restaurant_answers },
      :conditions => ["restaurant_answers.restaurant_id = ?", restaurant.id],
      :group => "chapters.id",
      :order => "chapters.position" }
  }

  scope :answered_for_page, lambda { |page, restaurant|
    { :joins => { :restaurant_questions => [:restaurant_answers, :question_pages] },
      :conditions => ["restaurant_answers.restaurant_id = ? AND question_pages.restaurant_feature_page_id = ?", restaurant.id, page.id],
      :group => "chapters.id",
      :order => "chapters.position" }
  }

  scope :answered_by_premium_users, {
    :joins => { :profile_questions => { :profile_answers => { :user => :subscription }}},
    :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
        Date.today],
    :group => "chapters.id",
    :order => "profile_answers.created_at DESC"
  }

  def title_with_topic
    "#{topic.title} - #{title}"
  end

  # is_self means the requestor is the user
  def previous_for_user(user, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    is_self_prefix = is_self ? "answered_" : ""

    self.topic.chapters.send("#{is_self_prefix}for_user", user).first(
        :conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
        :order => "chapters.#{sort_field} DESC")
  end

  def next_for_user(user, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    is_self_prefix = is_self ? "answered_" : ""

    self.topic.chapters.send("#{is_self_prefix}for_user", user).first(
        :conditions => ["chapters.#{sort_field} > ?", self.send(sort_field)], 
        :order => "chapters.#{sort_field} ASC")
  end

  def previous_for_context(restaurant, page, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    opts = { :conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
             :order => "chapters.#{sort_field} DESC" }

    if page.present? && is_self
      self.topic.chapters.for_page(page).first(opts)
    elsif page.present?
      self.topic.chapters.answered_for_page(page, restaurant).first(opts)
    else
      is_self_prefix = is_self ? "answered_" : ""
      self.topic.chapters.send("#{is_self_prefix}for_restaurant", restaurant).first(opts)
    end
  end

  def next_for_context(restaurant, page, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    opts = { :conditions => ["chapters.#{sort_field} > ?", self.send(sort_field)], 
             :order => "chapters.#{sort_field} ASC" }

    if page.present? && is_self
      self.topic.chapters.for_page(page).first(opts)
    elsif page.present?
      self.topic.chapters.answered_for_page(page, restaurant).first(opts)
    else
      is_self_prefix = is_self ? "answered_" : ""
      self.topic.chapters.send("#{is_self_prefix}for_restaurant", restaurant).first(opts)
    end
  end

  def previous
    sort_field = (self.position == 0 ? "id" : "position")
    self.topic.chapters.first(:conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
                              :order => "chapters.#{sort_field} DESC")
  end

  def next
    sort_field = (self.position == 0 ? "id" : "position")
    self.topic.chapters.first(:conditions => ["chapters.#{sort_field} > ?", self.send(sort_field)],
                              :order => "chapters.#{sort_field} DESC")
  end

  def questions_for_user(user)
    profile_questions.for_user(user)
  end

  def answered_for_user(user)
    profile_questions.answered_for_user(user)
  end

  def completion_percentage_for_user(user)
    if questions_for_user(user).count > 0
      ((answered_for_user(user).count.to_f / questions_for_user(user).count.to_f) * 100).to_i
    else
      0
    end
  end

  def published_for_user?(user)
    answered_for_user(user).count > 0
  end

  def question_count_for_restaurant(restaurant, page = nil)
    page.present? ? restaurant_questions.for_page(page).count : restaurant_questions.count
  end

  def answer_count_for_restaurant(restaurant, page)
    page.present? ?
      restaurant_questions.answered_for_page(page, restaurant).count :
      restaurant_questions.answered_for_restaurant(restaurant).count
  end

  def completion_percentage_for_restaurant(restaurant, page = nil)
    if question_count_for_restaurant(restaurant, page) > 0
      ((answer_count_for_restaurant(restaurant, page).to_f / question_count_for_restaurant(restaurant, page).to_f) * 100).to_i
    else
      0
    end
  end

  def published_for_user?(user)
    completion_percentage_for_user(user) > 0
  end

  def published_for_restaurant?(restaurant, page)
    answer_count_for_restaurant(restaurant, page) > 0
  end
  def name
    title
  end  
end
