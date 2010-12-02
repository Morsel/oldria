# == Schema Information
# Schema version: 20101104182252
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  description :string(255)
#

class Topic < ActiveRecord::Base

  has_many :chapters
  has_many :profile_questions, :through => :chapters

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => false, :scope => :responder_type
  validates_length_of :description, :maximum => 100

  default_scope :order => "topics.position ASC, topics.title ASC"

  named_scope :for_subject, lambda { |subject|
    if subject.is_a? User
      { :joins => { :chapters => { :profile_questions => :question_roles }},
        :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", subject.primary_employment.restaurant_role.id, subject.primary_employment.restaurant_role.class.name],
        :select => "distinct topics.*",
        :order => :position }
    elsif subject.is_a? RestaurantFeaturePage
      { :joins => { :chapters => { :profile_questions => :question_roles }},
        :conditions => ["question_roles.responder_id = ? AND question_roles.responder_type = ?", subject.id, subject.class.name],
        :select => "distinct topics.*",
        :order => :position }
    elsif subject.is_a? Restaurant
      { :conditions => { :responder_type => 'restaurant' },
        :select => "distinct topics.*",
        :order => :position }
    end
  }

  named_scope :answered_for_subject, lambda { |subject|
    { :joins => { :chapters => { :profile_questions => :profile_answers } },
      :conditions => ["profile_answers.responder_id = ? AND profile_answers.responder_type = ?", subject.id, subject.class.name],
      :select => "distinct topics.*",
      :order => :position }
  }

  named_scope :answered_for_page, lambda { |page, restaurant|
    { :joins => { :chapters => { :profile_questions => [:profile_answers, :question_roles] } },
      :conditions => { "`profile_answers`.responder_id" => restaurant.id,
                       "`profile_answers`.responder_type" => restaurant.class.name,
                       "`question_roles`.responder_id" => page.id,
                       "`question_roles`.responder_type"  => page.class.name],
      :select => "distinct topics.*",
      :order => :position }
  }

  def previous_for_subject(subject, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      Topic.for_subject(subject).first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)],
                                 :order => "#{sort_field} DESC")
    else
      Topic.answered_for_subject(subject).first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)],
                                          :order => "#{sort_field} DESC")
    end
  end

  def next_for_subject(subject, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      Topic.for_subject(subject).first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
                                 :order => "#{sort_field} ASC")
    else
      Topic.answered_for_subject(subject).first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)],
                                          :order => "#{sort_field} ASC")
    end
  end

  def question_count_for_subject(subject)
    self.profile_questions.for_subject(subject).count
  end

  def answer_count_for(subject, secondary_subject = nil)
    if secondary_subject
      self.profile_questions.answered_for_page(subject, secondary_subject).count
    else
      self.profile_questions.answered_for_subject(subject).count
    end
  end

  def completion_percentage(subject, secondary_subject = nil)
    if question_count_for_subject(subject) > 0
      ((answer_count_for(subject, secondary_subject).to_f / question_count_for_subject(subject).to_f) * 100).to_i
    else
      0
    end
  end

  def published?(subject, secondary_subject = nil)
    completion_percentage(subject, secondary_subject) >= 5
  end

end
