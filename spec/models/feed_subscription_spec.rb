# == Schema Information
#
# Table name: feed_subscriptions
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  feed_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec/spec_helper'

describe FeedSubscription do
  before do
    Factory(:feed_subscription)
  end

  should_belong_to :user
  should_belong_to :feed

  should_validate_presence_of :user_id, :feed_id
  should_validate_uniqueness_of :user_id, :scope => :feed_id
end
