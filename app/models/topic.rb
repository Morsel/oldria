class Topic < ActiveRecord::Base
  
  has_many :chapters
  has_many :profile_questions, :through => :chapters
  
  validates_presence_of :title
  
  default_scope :order => "topics.title ASC"
  
end
