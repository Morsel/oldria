class Chapter < ActiveRecord::Base
  
  belongs_to :topic
  has_many :profile_questions
  
  validates_presence_of :title, :topic_id
  
  default_scope :joins => :topic, :order => "topics.title ASC, chapters.title ASC"
  
  def title_with_topic
    "#{topic.title} - #{title}"
  end
  
  # for formtastic
  alias :to_label :title_with_topic
  
end
