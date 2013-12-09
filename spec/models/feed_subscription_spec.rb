require_relative '../spec_helper'

describe FeedSubscription do
  before do
    FactoryGirl.create(:feed_subscription)
  end

  it { should belong_to :user }
  it { should belong_to :feed }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :feed_id }
  it { should validate_uniqueness_of(:user_id).scoped_to(:feed_id) }
end
