require_relative '../spec_helper'

describe FeedSubscription do
  before do
    Factory(:feed_subscription)
  end

  should_belong_to :user
  should_belong_to :feed

  should_validate_presence_of :user_id, :feed_id
  should_validate_uniqueness_of :user_id, :scope => :feed_id
end
