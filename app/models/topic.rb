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
    Topic.for_user(user).find(:first, :conditions => ["topics.position < ?", self.position])
  end
  
  def next_for_user(user)
    Topic.for_user(user).find(:first, :conditions => ["topics.position > ?", self.position])
  end
  
end
