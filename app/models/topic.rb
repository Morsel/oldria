# == Schema Information
# Schema version: 20120217190417
#
# Table name: topics
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  description :string(255)
#  type        :string(255)
#

class Topic < ActiveRecord::Base

  has_many :chapters
  has_many :profile_questions, :through => :chapters

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => false, :scope => :type
  validates_length_of :description, :maximum => 100

  default_scope :order => "topics.position ASC, topics.title ASC"

  scope :user_topics, :conditions => "type IS NULL"

  scope :for_user, lambda { |user|
    { :joins => { :chapters => { :profile_questions => :question_roles }},
      :conditions => ["question_roles.restaurant_role_id = ? AND topics.type IS NULL",
                      user.primary_employment.restaurant_role.id],
      :select => "distinct topics.*",
      :order => :position }
  }

  scope :answered_for_user, lambda { |user|
    { :joins => { :chapters => { :profile_questions => :profile_answers } },
      :conditions => ["profile_answers.user_id = ?", user.id],
      :select => "distinct topics.*",
      :order => :position }
  }

  scope :answered, {
    :joins => { :chapters => { :profile_questions => :profile_answers } },
    :select => "distinct topics.*",
    :order => "profile_answers.created_at DESC"
  }

  scope :answered_by_premium_users, {
    :joins => { :chapters => { :profile_questions => { :profile_answers => { :user => :subscription }}}},
    :conditions => ["subscriptions.id IS NOT NULL AND (subscriptions.end_date IS NULL OR subscriptions.end_date >= ?)",
        Date.today],
    :select => "distinct topics.*",
    :order => "profile_answers.created_at DESC"
  }

  scope :without_travel, :conditions => ["topics.title != ?", "Travel Guide"]
  scope :travel, :conditions => { :title => "Travel Guide" }

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

  def previous
    sort_field = (self.position == 0 ? "id" : "position")
    Topic.first(:conditions => ["topics.#{sort_field} < ?", self.send(sort_field)], :order => "#{sort_field} DESC")
  end

  def next
    sort_field = (self.position == 0 ? "id" : "position")
    Topic.first(:conditions => ["topics.#{sort_field} > ?", self.send(sort_field)], :order => "#{sort_field} DESC")
  end

  def question_count_for_user(user)
    self.profile_questions.for_user(user).count
  end
  
  def answer_count_for(user)
    self.profile_questions.answered_for_user(user).count
  end
  
  def completion_percentage(user)
    if question_count_for_user(user) > 0
      ((answer_count_for(user).to_f / question_count_for_user(user).to_f) * 100).to_i
    else
      0
    end
  end
  
  def published?(user)
    completion_percentage(user) > 0
  end

  def self.travel
    first(:conditions => { :title => "Travel Guide" })
  end

end
