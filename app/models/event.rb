class Event < ActiveRecord::Base
  
  belongs_to :restaurant
  
  validates_presence_of :title, :start_at
  
  def date
    start_at
  end
  
end
