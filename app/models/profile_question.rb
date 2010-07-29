class ProfileQuestion < ActiveRecord::Base

  belongs_to :chapter
  
  validates_presence_of :title, :chapter_id
    
  def topic
    chapter.topic
  end
  
end
