require_relative '../spec_helper'

describe Feed do
  it { Feed.scoped.to_sql.should == Feed.order(:position).to_sql }
  # it { should have_default_scope :order => :position }
  it { Feed.featured.to_sql.should == "SELECT `feeds`.* FROM `feeds`  WHERE (featured=1) ORDER BY position" }
  # it { should have_scope :featured, :conditions => ['featured=?', true] }
  it { Feed.uncategorized.to_sql.should == "SELECT `feeds`.* FROM `feeds`  WHERE `feeds`.`feed_category_id` IS NULL ORDER BY position" }
  # it { should have_scope :uncategorized, :conditions => {:feed_category_id => nil} }
  it { should belong_to :feed_category }
  it { should have_many :feed_entries }
  it { should have_many :feed_subscriptions }
  it { should have_many(:users).through(:feed_subscriptions) }


  it "should fetch and parse the feed url before saving" do
    feed = Feed.new(:feed_url => 'http://feeds.feedburner.com/neoteric-blog')
    feed.no_entries = true
    feed.title.should be_blank
    feed.save
    feed.title.should == "Neoteric Design, Inc."
  end

  it "should not fetch and parse if the given fields are passed in when new" do
    Feed.any_instance.stubs(:fetch_and_parse).raises(NoMethodError) # Guards against remote call
    feed = Feed.new(
      :feed_url => 'http://feeds.feedburner.com/neoteric-blog',
      :url => 'http://www.neotericdesign.com',
      :title => 'Arbitrary Title'
    )
    feed.no_entries = true
    feed.save
    feed.title.should == "Arbitrary Title"
  end

  it "should be sortable" do
    feed2 = FactoryGirl.create(:feed, :title => 'First feed entered')
    feed1 = FactoryGirl.create(:feed, :title => 'Second')
    Feed.last.move_to_top
    Feed.all.should == [feed1,feed2]
  end

  context "entries" do
    it "should update" do
      feed = FactoryGirl.create( :feed,
                      :title => 'Neoteric',
                      :feed_url => 'http://feeds.feedburner.com/neoteric-blog')
      feed.update_entries!
      feed.reload
      feed.feed_entries.all.should_not be_empty
    end

  end

  context "feed url normalization" do
    it "should change feed:// protocol to http:// protocol (Safari)" do
      feed = Feed.new(:feed_url => 'feed://feeds.feedburner.com/blogspot/MKuf')
      feed.no_entries = true
      feed.save
      feed.feed_url.should == 'http://feeds.feedburner.com/blogspot/MKuf'
    end
  end
end
