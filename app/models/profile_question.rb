# == Schema Information
# Schema version: 20100825200638
#
# Table name: profile_questions
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer
#  chapter_id :integer
#

class ProfileQuestion < ActiveRecord::Base

  belongs_to :chapter
  has_many :question_roles
  has_many :restaurant_roles, :through => :question_roles
  has_many :profile_answers
  
  validates_presence_of :title, :chapter_id, :restaurant_roles
  validates_uniqueness_of :title, :scope => :chapter_id, :case_sensitive => false
  
  def topic
    chapter.topic
  end
  
end
