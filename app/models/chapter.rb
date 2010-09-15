# == Schema Information
# Schema version: 20100802191740
#
# Table name: chapters
#
#  id         :integer         not null, primary key
#  topic_id   :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer         default(0)
#

class Chapter < ActiveRecord::Base
  
  belongs_to :topic
  has_many :profile_questions
  
  validates_presence_of :title, :topic_id
  validates_uniqueness_of :title, :scope => :topic_id, :case_sensitive => false
  
  default_scope :joins => :topic, :order => "topics.title ASC, chapters.title ASC"
  
  named_scope :for_user, lambda { |user|
    { :joins => { :profile_questions => { :restaurant_roles => :employments }}, 
    :conditions => { :employments => { :id => user.primary_employment.id } },
    :select => "distinct chapters.*",
    :order => :position }
  }
  
  def title_with_topic
    "#{topic.title} - #{title}"
  end
  
  def previous_for_user(user)
    self.topic.chapters.for_user(user).find(:first, :conditions => ["chapters.position < ?", self.position])
  end
  
  def next_for_user(user)
    self.topic.chapters.for_user(user).find(:first, :conditions => ["chapters.position > ?", self.position])
  end
  
end
