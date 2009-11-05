require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  should_have_many :statuses, :dependent => :destroy
  should_have_many :followings, :foreign_key => 'follower_id', :dependent => :destroy
  should_have_many :media_requests, :foreign_key => 'sender_id'
  should_have_many :media_request_conversations, :foreign_key => "recipient_id"
  should_have_many :managed_restaurants, :foreign_key => "manager_id", :class_name => "Restaurant"
  should_have_and_belong_to_many :roles
  should_belong_to :james_beard_region
  should_belong_to :account_type
  should_have_many :employments, :foreign_key => "employee_id"
  should_have_many :restaurants, :through => :employments
  
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

  context "searching using ::find_all_by_name" do
    before(:each) do
      @johnny = Factory(:user, :first_name => "Johnny", :last_name => "McArthur")
      @john   = Factory(:user, :first_name => "John", :last_name => "Salsman")
      @amy    = Factory(:user, :first_name => "Amy", :last_name => "Fisher")
    end

    it "should allow searching both columns simultaneously" do
      users = User.find_all_by_name("John McArth")
      users.should include(@johnny)
      users.should_not include(@john)
    end
    
    it "should allow searching using only last name" do
      users = User.find_all_by_name("McArth")
      users.should include(@johnny)
      users.should_not include(@john)
    end
    
    it "should allow search using only first name" do
      users = User.find_all_by_name("John")
      users.should include(@johnny)
      users.should include(@john)
    end
    
    it "should allow search using only first name (with leading/trailing spaces)" do
      users = User.find_all_by_name("  John ")
      users.should include(@johnny)
      users.should include(@john)
      users.should_not include(@amy)
    end

    it "should be able to find by name" do
      user = Factory(:user, :first_name => "Hamburg", :last_name => "Erlang" )
      User.find_by_name("Hamburg Erlang").should == user
    end

    it "should be able to find all by name for autocompletion" do
      john = Factory(:user, :first_name => "John", :last_name => "Dorian" )
      joe = Factory(:user, :first_name => "Joe", :last_name => "Doe" )
      found = User.find_all_by_name("Jo Do")
      found.should include(john)
      found.should include(joe)
    end
  end
  
  context "following" do
    it "should know if he/she is following a user" do
      guy  = Factory(:user, :username => 'guy')
      girl = Factory(:user, :username => 'girl')
      guy.friends << girl
      guy.should be_following(girl)
    end
  end
  
  context "twitter and oauth" do
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
  
  context "media_requests" do
    before(:each) do
      @user = Factory(:media_user)
      @user.has_role! :media
    end

    it "should have many media_requests" do
      MediaRequest.destroy_all
      @user.media_requests.should == []
    end
  end
  
  context "sending invitations" do
    it "should send from UserMailer" do
      user = Factory(:user)
      user.send_invitation = true
      UserMailer.expects(:deliver_employee_invitation!).with(user)
      user.deliver_invitation_message!
      user.send_invitation.should be_nil
    end
  end
end
