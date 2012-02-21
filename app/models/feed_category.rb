# == Schema Information
# Schema version: 20120217190417
#
# Table name: feed_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_feed_categories_on_id  (id) UNIQUE
#

class FeedCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :feeds, :order => :position
end
