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
  validates_uniqueness_of :title, :scope => :topic_id
  
  default_scope :joins => :topic, :order => "topics.title ASC, chapters.title ASC"
  
  def title_with_topic
    "#{topic.title} - #{title}"
  end
  
end
