class Topic < ActiveRecord::Base
  
  has_many :chapters
  has_many :profile_questions, :through => :chapters
  
end
