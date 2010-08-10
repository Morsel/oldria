# == Schema Information
# Schema version: 20100810184557
#
# Table name: profile_questions
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer         default(0)
#

class ProfileQuestion < ActiveRecord::Base

  has_and_belongs_to_many :chapters
  
  validates_presence_of :title
      
  def topics
    chapters.map(&:topic)
  end
  
end
