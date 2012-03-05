# == Schema Information
#
# Table name: feed_categories
#
#  id         :integer         not null, primary key, indexed
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class FeedCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :feeds, :order => :position
end
