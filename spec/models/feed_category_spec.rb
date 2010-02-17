# == Schema Information
#
# Table name: feed_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec/spec_helper'

describe FeedCategory do
  should_have_many :feeds, :order => :position
end
