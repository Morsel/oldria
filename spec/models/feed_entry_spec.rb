require 'spec_helper'

describe FeedEntry do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:feed_entry)
    Factory(:feed_entry, :guid => 'a_valid_guid_000')
  end

  should_belong_to :feed
  should_validate_uniqueness_of :guid

  it "should create a new instance given valid attributes" do
    FeedEntry.create!(@valid_attributes)
  end

end
