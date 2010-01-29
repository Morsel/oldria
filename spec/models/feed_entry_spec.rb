require 'spec_helper'

describe FeedEntry do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:feed_entry)
  end

  should_belong_to :feed

  it "should create a new instance given valid attributes" do
    FeedEntry.create!(@valid_attributes)
  end

end
