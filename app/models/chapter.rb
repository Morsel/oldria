# == Schema Information
# Schema version: 20101104182252
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

  validates_presence_of :title, :topic_id
  validates_uniqueness_of :title, :scope => :topic_id, :case_sensitive => false
  validates_length_of :description, :maximum => 100

  default_scope :include => :topic, :order => "topics.title ASC, chapters.title ASC"

  named_scope :for_user, lambda { |user|
    { :joins => { :profile_questions => :question_roles },
      :conditions => ["question_roles.restaurant_role_id = ?", user.primary_employment.restaurant_role.id],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :for_restaurant, lambda { |restaurant|
    { :joins => :topic,
      :conditions => ["topics.type = 'RestaurantTopic'"],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :for_page, lambda { |page|
    { :joins => { :restaurant_questions => :question_pages },
      :conditions => ["question_pages.restaurant_feature_page_id = ?", page.id],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :answered_for_user, lambda { |user|
    { :joins => { :profile_questions => :profile_answers },
      :conditions => ["profile_answers.user_id = ?", user.id],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :answered_for_restaurant, lambda { |restaurant|
    { :joins => { :restaurant_questions => :restaurant_answers },
      :conditions => ["restaurant_answers.restaurant_id = ?", restaurant.id],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :answered_for_page, lambda { |page, restaurant|
    { :joins => { :restaurant_questions => [:restaurant_answers, :question_pages] },
      :conditions => ["restaurant_answers.restaurant_id = ? AND question_pages.restaurant_feature_page_id = ?", restaurant.id, page.id],
      :select => "distinct chapters.*",
      :order => :position }
  }

  def title_with_topic
    "#{topic.title} - #{title}"
  end

  # Context should be a user, restaurant, or page, to match the named scopes above. is_self means the requestor is the owner.
  def previous_for_context(context, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    is_self_prefix = is_self ? "answered_" : ""
    context_name = filter_name(context)

    self.topic.chapters.send("#{is_self_prefix}for_#{context_name}", context).first(
        :conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
        :order => "chapters.#{sort_field} DESC")
  end

  def next_for_context(context, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    context_name = filter_name(context)

    chapters = is_self ? 
        self.topic.chapters.send("for_#{context_name}", context) : 
        self.topic.chapters.send("answered_for_#{context_name}", context)

    chapters.find(:first, :conditions => ["chapters.#{sort_field} > ?", self.send(sort_field)], :order => "chapters.#{sort_field} ASC")
  end

  def filter_name(context)
    if context.is_a?(User)
      "user"
    elsif context.is_a?(Restaurant)
      "restaurant"
    elsif context.is_a?(RestaurantFeaturePage)
      "page"
    end
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
    completion_percentage_for_restaurant(restaurant, page) > 0
  end

end
