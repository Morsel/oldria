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

  belongs_to :chapter
  has_and_belongs_to_many :restaurant_roles
  
  validates_presence_of :title, :chapter_id
  
  def topic
    chapter.topic
  end
  
end
