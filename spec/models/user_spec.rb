require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should be valid" do
    Factory(:user, :username => 'normal').should be_valid
  end

  it "should handle #name" do
    u = Factory(:user, :first_name => "Ben", :last_name => "Davis" )
    u.name.should eql("Ben Davis")
  end

  describe "#name=()" do
    it "should save the name" do
      u = Factory.build(:user, :first_name => '', :last_name => '')
      u.name = "Ben Davis"
      u.save
      u.first_name.should eql("Ben")
      u.last_name.should eql("Davis")
    end

    it "should drop everything but the first and last names" do
      u = User.new
      u.name = "John Q. Morris"
      u.first_name.should == "John"
      u.last_name.should == "Morris"
    end

    it "should only update first_name if one name is given" do
      u = User.new
      u.name = "Jimmy"
      u.first_name.should == "Jimmy"
      u.last_name.should be_blank
    end
  end
end

describe User, "following" do
  it "should know if he/she is following a user" do
    guy  = Factory(:user, :username => 'guy')
    girl = Factory(:user, :username => 'girl')
    guy.friends << girl
    guy.should be_following(girl)
  end
end

describe User, "twitter and oauth" do
  before(:each) do
    @user = User.new(:atoken => 'atoken', :asecret => 'asecret')
    @twitter_oauth = TwitterOAuth::Client.new(:consumer_key => 'key', :consumer_secret => 'secret')
    @user.stubs(:twitter_oauth).returns(@twitter_oauth)
    @user.stubs(:twitter_client).returns(@twitter_oauth)
    @tweet = JSON.parse( File.new(File.dirname(__FILE__) + '/../fixtures/twitter_update.json').read )
  end

  it "authorize from access token and secret" do
    @user.twitter_client.should_not be_nil
  end

  it "should retrieve friend requests" do
    @twitter_oauth.stubs(:friends_timeline).returns(@tweet)
    @user.twitter_client.friends_timeline.first['text'].should eql("Best American flag etiquette video series I've seen all month!  http://bit.ly/eiOZe")
  end
end
