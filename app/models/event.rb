class Event < ActiveRecord::Base
  
  belongs_to :restaurant
  
  validates_presence_of :title, :start_at
end
