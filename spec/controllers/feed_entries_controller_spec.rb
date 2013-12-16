require_relative '../spec_helper'

RSpec::Matchers.define :render_nothing do |expected|
  match do |actual|
   actual.body.strip == ''
  end
end
#CIS simple_matcher is deprecated in rspec2
# def render_nothing
#   simple_matcher(:nothing) do |response|
#     response.body.strip == ''
#   end
# end

describe FeedEntriesController do
  integrate_views

  before do
    @feed_entry = FactoryGirl.create(:feed_entry)
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
