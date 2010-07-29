class ProfileQuestion < ActiveRecord::Base

  belongs_to :chapter
  
  validates_presence_of :title, :chapter
    
  def topic
    chapter.topic
  end
  
end
