class FeedCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :feeds, :order => :position
end
