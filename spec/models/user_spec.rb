require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should be valid" do
    Factory(:user).should be_valid
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
