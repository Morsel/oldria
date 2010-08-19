# == Schema Information
# Schema version: 20100819192128
#
# Table name: profile_questions
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ProfileQuestion < ActiveRecord::Base

  has_many :chapter_question_memberships
  has_many :chapters, :through => :chapter_question_memberships
  
  validates_presence_of :title, :chapters
  
  def topics
    chapters.map(&:topic)
  end
  
end
