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
  has_and_belongs_to_many :profile_questions
  
  validates_presence_of :title, :topic_id
  
  default_scope :joins => :topic, :order => "topics.title ASC, chapters.title ASC"
  
  def title_with_topic
    "#{topic.question_roles_description} - #{topic.title} - #{title}"
  end
  
  # for formtastic
  alias :to_label :title_with_topic
  
end
