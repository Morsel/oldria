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

  validates_presence_of :title, :topic_id
  validates_uniqueness_of :title, :scope => :topic_id, :case_sensitive => false
  validates_length_of :description, :maximum => 100

  default_scope :joins => :topic, :order => "topics.title ASC, chapters.title ASC"

  named_scope :for_user, lambda { |user|
    { :joins => { :profile_questions => :question_roles },
      :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", user.primary_employment.restaurant_role.id, user.primary_employment.restaurant_role.class.name],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :answered_for_user, lambda { |user|
    { :joins => { :profile_questions => :profile_answers },
      :conditions => ["profile_answers.user_id = ?", user.id],
      :select => "distinct chapters.*",
      :order => :position }
  }

  def title_with_topic
    "#{topic.title} - #{title}"
  end

  def previous_for_user(user, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      self.topic.chapters.for_user(user).first(:conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
                                               :order => "#{sort_field} DESC")
    else
      self.topic.chapters.answered_for_user(user).first(:conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
                                                        :order => "#{sort_field} DESC")
    end
  end

  def next_for_user(user, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    chapters = is_self ? self.topic.chapters.for_user(user) : self.topic.chapters.answered_for_user(user)
    chapters.find(:first,
                  :conditions => ["chapters.#{sort_field} > ?", self.send(sort_field)],
                  :order => "#{sort_field} ASC")
  end

  def question_count_for_user(user)
    self.profile_questions.for_user(user).count
  end

  def answer_count_for_user(user)
    self.profile_questions.answered_for_user(user).count
  end

  def completion_percentage(user)
    if question_count_for_user(user) > 0
      ((answer_count_for_user(user).to_f / question_count_for_user(user).to_f) * 100).to_i
    else
      0
    end
  end

  def published?(user)
    completion_percentage(user) >= 5
  end

end
