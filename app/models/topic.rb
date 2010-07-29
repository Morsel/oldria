class Topic < ActiveRecord::Base
  
  has_many :chapters
  has_many :profile_questions, :through => :chapters
  
  default_scope :order => "topics.title ASC"
  
end
