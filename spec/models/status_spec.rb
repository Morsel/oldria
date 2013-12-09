require_relative '../spec_helper'

describe Status do
  before(:each) do
    @joe = FactoryGirl.create(:user, :username => 'joe', :email => 'joe@example.com')
    @bob = FactoryGirl.create(:twitter_user, :username => 'bob', :email => 'bob@example.com')
    @post1 = FactoryGirl.create(:status, :user => @joe, :created_at => 3.minutes.ago)
    @post2 = FactoryGirl.create(:status, :user => @bob, :created_at => 2.minutes.ago)
    @post3 = FactoryGirl.create(:status, :user => @joe, :created_at => 1.minutes.ago)
  end
  
  describe "friend feed" do
    it "does something" do
      guy = FactoryGirl.create(:user, :username => 'guy', :email => 'guy@com.com')
      guy.friends << @joe
      Status.friends_of_user(guy).should == [@post3, @post1]
    end
  end

  describe "order" do
    it "should return lists of status in reverse-chrono order" do
      Status.all.should eql([@post3, @post2, @post1])
    end
  end

  describe "html stripping" do
    it "should strip html content (example 1)" do
      status = FactoryGirl.build(:status, :message => '<h1>This is a message</h1>')
      status.strip_html.should == 'This is a message'
      status.save
      status.message.should == 'This is a message'
    end

    it "should strip html content before save" do
      status = FactoryGirl.create(:status, :message => '<em>This</em> is a <a href="http://www.google.com">message</a>')
      status.message.should == 'This is a message'
    end
  end

end

describe Status, "updating Twitter" do
  before(:each) do
    @user = FactoryGirl.create(:twitter_user, :email => 'tweetie@example.com')
    @tweet = JSON.parse( File.new(File.dirname(__FILE__) + '/../fixtures/twitter_response.json').read)
  end

  it "should update Twitter on save" do
    @user.twitter_client.stubs(:update).returns(@tweet)
    s = FactoryGirl.build(:status, :user => @user, :queue_for_social_media => true, :message => 'A Tweet')
    s.save
    s.twitter_id.should == 3291760836
    s.queue_for_social_media.should be_nil
  end
end

describe Status, "updating Facebook" do
  before(:each) do
    @user = FactoryGirl.create(:facebook_user)
  end

  it "should update Twitter on save" do
    message = JSON.parse( File.new(File.dirname(__FILE__) + '/../fixtures/facebook_response.json').read)
    @user.facebook_user.stubs(:feed_create).returns(message)
    s = FactoryGirl.build(:status, :user => @user, :queue_for_facebook => true, :message => 'My status')
    s.save
    s.facebook_id.should_not be_nil
    s.queue_for_social_media.should be_nil
  end

end

