# == Schema Information
# Schema version: 20100825200638
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#

class Topic < ActiveRecord::Base

  has_many :chapters
  has_many :profile_questions, :through => :chapters

  validates_presence_of :title
  validates_uniqueness_of :title, :case_sensitive => false
  
  default_scope :order => "topics.position ASC, topics.title ASC"
  
  named_scope :for_user, lambda { |user|
    { :joins => { :chapters => { :profile_questions => { :restaurant_roles => :employments }}}, 
    :conditions => { :employments => { :id => user.primary_employment.id } },
    :select => "distinct topics.*",
    :order => :position }
  }

  def previous_for_user(user)
    sort_field = (self.position == 0 ? "id" : "position")
    Topic.for_user(user).find(:first, 
        :conditions => ["topics.#{sort_field} < ?", self.send(sort_field)], :order => "#{sort_field} DESC")
  end
  
  def next_for_user(user)
    sort_field = (self.position == 0 ? "id" : "position")
    Topic.for_user(user).find(:first, 
        :conditions => ["topics.#{sort_field} > ?", self.send(sort_field)], :order => "#{sort_field} ASC")
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
    completion_percentage(user) > 30
  end
  
end
