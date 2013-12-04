require_relative '../spec_helper'

def render_nothing
  simple_matcher(:nothing) do |response|
    response.body.strip == ''
  end
end

describe FeedEntriesController do
  integrate_views

  before do
    @feed_entry = Factory.stub(:feed_entry)
    FeedEntry.stubs(:find).returns(@feed_entry)
  end

  describe "PUT read" do
    before do
      put :read, :id => '3'
    end

    it "should assign a feed_entry" do
      assigns[:feed_entry].should == @feed_entry
    end

    it "should render nothing" do
      response.should render_nothing
    end
  end
end
