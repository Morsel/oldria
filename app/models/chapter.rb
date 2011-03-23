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

  named_scope :for_subject, lambda { |subject|
    if subject.is_a? User
      { :joins => { :profile_questions => :question_roles },
        :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", subject.primary_employment.restaurant_role.id, subject.primary_employment.restaurant_role.class.name],
        :select => "distinct chapters.*",
        :order => :position }
    elsif subject.is_a? RestaurantFeaturePage
      { :joins => { :profile_questions => :question_roles },
        :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", subject.id, subject.class.name],
        :select => "distinct chapters.*",
        :order => :position }
    elsif subject.is_a? Restaurant
      { :joins => :topic,
        :conditions => ["topics.type = 'RestaurantTopic'"],
        :select => "distinct chapters.*",
        :order => :position }
    end
  }

  named_scope :answered_for_subject, lambda { |subject|
    { :joins => { :profile_questions => :profile_answers },
      :conditions => ["profile_answers.responder_id = ? AND profile_answers.responder_type = ?", subject.id, subject.class.name],
      :select => "distinct chapters.*",
      :order => :position }
  }

  named_scope :answered_for_page, lambda { |page, restaurant|
    { :joins => { :profile_questions => [:profile_answers, :question_roles] },
      :conditions => ["profile_answers.responder_id = ? AND profile_answers.responder_type = ? AND question_roles.responder_id = ? AND question_roles.responder_type = ?", restaurant.id, restaurant.class.name, page.id, page.class.name],
      :select => "distinct chapters.*",
      :order => :position }
  }

  def title_with_topic
    "#{topic.title} - #{title}"
  end

  def previous_for_subject(subject, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      self.topic.chapters.for_subject(subject).first(
        :conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
        :order => "#{sort_field} DESC")
    else
      self.topic.chapters.answered_for_subject(subject).first(
        :conditions => ["chapters.#{sort_field} < ?", self.send(sort_field)],
        :order => "#{sort_field} DESC")
    end
  end

  def next_for_subject(subject, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    chapters = is_self ? self.topic.chapters.for_subject(subject) : self.topic.chapters.answered_for_subject(subject)
    chapters.find(:first,
                  :conditions => ["chapters.#{sort_field} > ?", self.send(sort_field)],
                  :order => "#{sort_field} ASC")
  end

  def question_count_for_subject(subject)
    self.profile_questions.for_subject(subject).count
  end

  def answer_count_for_subject(subject, secondary_subject = nil)
    if secondary_subject
      self.profile_questions.answered_for_page(subject, secondary_subject).count
    else
      self.profile_questions.answered_for_subject(subject).count
    end
  end

  def completion_percentage(subject, secondary_subject = nil)
    if question_count_for_subject(subject) > 0
      ((answer_count_for_subject(subject, secondary_subject).to_f / question_count_for_subject(subject).to_f) * 100).to_i
    else
      0
    end
  end

  def published?(subject, secondary_subject = nil)
    completion_percentage(subject, secondary_subject) > 0
  end

end
