class Cuisine < ActiveRecord::Base
  has_many :restaurants
  validates_presence_of :name
  default_scope :order => :name
end
