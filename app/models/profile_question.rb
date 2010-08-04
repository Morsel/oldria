# == Schema Information
# Schema version: 20100802191740
#
# Table name: profile_questions
#
#  id         :integer         not null, primary key
#  chapter_id :integer
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer         default(0)
#

class ProfileQuestion < ActiveRecord::Base

  belongs_to :chapter
  
  validates_presence_of :title, :chapter_id
    
  def topic
    chapter.topic
  end
  
end
