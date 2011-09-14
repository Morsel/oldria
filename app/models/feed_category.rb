# == Schema Information
# Schema version: 20110831230326
#
# Table name: feed_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FeedCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :feeds, :order => :position
end
