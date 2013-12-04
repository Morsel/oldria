require_relative '../spec_helper'

describe FeedCategory do
  should_have_many :feeds, :order => :position
end
