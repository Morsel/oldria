class SubjectMatter < ActiveRecord::Base
  has_many :responsibilities
  has_many :employments, :through => :responsibilities
  validates_presence_of :name
end
