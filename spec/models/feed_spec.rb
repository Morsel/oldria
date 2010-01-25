require 'spec/spec_helper'

describe Feed do
  should_have_default_scope :order => :position
  should_have_scope :featured, :conditions => {:featured => true}

  it "should fetch and parse the feed url before saving" do
    feed = Feed.new(:feed_url => 'http://feeds.neotericdesign.com/neotericdesign')
    feed.title.should be_blank
    feed.save
    feed.title.should == "Neoteric Design Blog"
  end

  it "should not fetch and parse if the given fields are passed in when new" do
    Feedzirra::Feed.stubs(:fetch_and_parse).raises(NoMethodError) # Guards against remote call
    feed = Feed.new(
      :feed_url => 'http://feeds.neotericdesign.com/neotericdesign',
      :url => 'http://www.neotericdesign.com',
      :title => 'Arbitrary Title'
    )
    feed.save
    feed.title.should == "Arbitrary Title"
  end

  it "should be sortable" do
    feed2 = Factory(:feed, :title => 'First feed entered')
    feed1 = Factory(:feed, :title => 'Second')
    Feed.last.move_to_top
    Feed.all.should == [feed1,feed2]
  end

end
