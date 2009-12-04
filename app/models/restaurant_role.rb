class RestaurantRole < ActiveRecord::Base
  has_many :employments
  validates_presence_of :name
  default_scope :order => :name
end
