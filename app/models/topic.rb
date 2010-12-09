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
  validates_uniqueness_of :title, :case_sensitive => false
  validates_length_of :description, :maximum => 100
  
  default_scope :order => "topics.position ASC, topics.title ASC"
  
  named_scope :for_user, lambda { |user|
    { :joins => { :chapters => { :profile_questions => :restaurant_roles }}, 
    :conditions => ["restaurant_roles.id = ?", user.primary_employment.restaurant_role.id],
    :select => "distinct topics.*",
    :order => :position }
  }

  named_scope :answered_for_user, lambda { |user|
    { :joins => { :chapters => { :profile_questions => :profile_answers } },
      :conditions => ["profile_answers.user_id = ?", user.id],
      :select => "distinct topics.*",
      :order => :position }
  }
    
  def previous_for_user(user, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      Topic.for_user(user).first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)], 
                                 :order => "#{sort_field} DESC")
    else
      Topic.answered_for_user(user).first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)], 
                                          :order => "#{sort_field} DESC")
    end
  end
  
  def next_for_user(user, is_self = false)
    sort_field = (self.position == 0 ? "id" : "position")
    if is_self
      Topic.for_user(user).first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)], 
                                 :order => "#{sort_field} ASC")
    else
      Topic.answered_for_user(user).first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)], 
                                          :order => "#{sort_field} ASC")
    end
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
    completion_percentage(user) > 0
  end
  
end
