# == Schema Information
# Schema version: 20100721223109
#
# Table name: users
#
#  id                    :integer         not null, primary key
#  username              :string(255)
#  email                 :string(255)
#  crypted_password      :string(255)
#  password_salt         :string(255)
#  perishable_token      :string(255)
#  persistence_token     :string(255)     not null
#  created_at            :datetime
#  updated_at            :datetime
#  confirmed_at          :datetime
#  last_request_at       :datetime
#  atoken                :string(255)
#  asecret               :string(255)
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  first_name            :string(255)
#  last_name             :string(255)
#  james_beard_region_id :integer
#  publication           :string(255)
#  role                  :string(255)
#  facebook_id           :integer
#  facebook_access_token :string(255)
#

require 'spec/spec_helper'

describe User do
  should_have_many :statuses, :dependent => :destroy
  should_have_many :followings, :foreign_key => 'follower_id', :dependent => :destroy
  should_have_many :media_requests, :foreign_key => 'sender_id'
  should_have_many :managed_restaurants, :foreign_key => "manager_id", :class_name => "Restaurant"
  should_belong_to :james_beard_region
  should_have_many :employments, :foreign_key => "employee_id"
  should_have_many :restaurants, :through => :employments
  should_have_many :discussion_seats
  should_have_many :discussions, :through => :discussion_seats
  should_have_many :posted_discussions, :class_name => 'Discussion', :foreign_key => 'poster_id'
  should_have_many :feed_subscriptions
  should_have_many :feeds, :through => :feed_subscriptions

  should_validate_presence_of :email
  should_validate_acceptance_of :agree_to_contract

  it "should be valid" do
    Factory(:user, :username => 'normal').should be_valid
  end

  it "should allow a contractual virtual attribute" do
    user = Factory.build(:user)
    user.agree_to_contract = true
  end

  it "should only allow alphanumeric characters in username" do
    user = Factory.build(:user, :username => nil)
    user.username = "chef.bacle"
    user.should_not be_valid
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

    it "should save the name for two names only" do
      u = Factory.build(:user, :first_name => '', :last_name => '')
      u.name = "Ben Davis Smith"
      u.save
      u.first_name.should eql("Ben")
      u.last_name.should eql("Davis Smith")
    end

    it "should handle hyphenated names" do
      u = Factory.build(:user, :first_name => '', :last_name => '')
      u.name = "Ben Davis-Smith"
      u.save
      u.first_name.should eql("Ben")
      u.last_name.should eql("Davis-Smith")
    end

    it "should drop everything but the first and last names" do
      u = User.new
      u.name = "John Q. Morris"
      u.first_name.should == "John"
      u.last_name.should == "Q. Morris"
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

    it "should find twitter username when it's available" do
      @twitter_oauth.stubs(:user).returns([{'user' => {'screen_name' => 'twitter_username'}}])
      @user.twitter_username.should == "twitter_username"
    end

    it "should return nil when twitter username isn't available" do
      @twitter_oauth.stubs(:user).returns(nil)
      @user.twitter_username.should be_nil
    end

    it "should return nil when twitter returns blank" do
      @twitter_oauth.stubs(:user).returns([])
      @user.twitter_username.should be_nil
    end
  end

  context "who are media" do
    before(:each) do
      @user = Factory(:media_user)
    end

    it "should have many (sent) media_requests" do
      MediaRequest.destroy_all
      @user.media_requests.should == []
    end
  end

  context "non-media" do
    before do
      @restaurant = Factory(:restaurant)
      @user = Factory(:user)
      @employment = Factory(:employment, :employee => @user, :restaurant => @restaurant, :omniscient => true)
    end

    it "should be able to see media requests" do
      search = EmploymentSearch.new(:conditions => {:restaurant_id_is => "#{@restaurant.id}"})
      request = Factory(:media_request, :employment_search => search)
      discussion = request.discussion_with_restaurant(@restaurant)
      @user.viewable_media_request_discussions.should == [discussion]
    end
  end

  context "sending invitations" do
    it "should send from UserMailer" do
      user = Factory(:user)
      user.send_invitation = true
      UserMailer.expects(:deliver_employee_invitation!)
      user.deliver_invitation_message!
      user.send_invitation.should be_nil
    end
  end

  context "allowed subject matters" do
    before(:each) do
      @normal_subject = Factory(:subject_matter, :name => "Beer")
      @special_subject = Factory(:subject_matter, :name => "Admin (RIA)")
    end

    it "should include all but admin_only by default" do
      user = Factory(:user)
      user.allowed_subject_matters.should == [@normal_subject]
    end

    it "should include all for admins" do
      user = Factory(:admin)
      user.allowed_subject_matters.should include(@normal_subject)
      user.allowed_subject_matters.should include(@special_subject)
    end
  end

  context "coworkers" do
    before do
      @restaurant = Factory(:restaurant)
      @joe = Factory(:user)
      @sam = Factory(:user)
      Factory(:employment, :employee => @joe, :restaurant => @restaurant)
      Factory(:employment, :employee => @sam, :restaurant => @restaurant)
    end

    it "should be a list of users that work at any of the same restaurants" do
      @joe.coworkers.should include(@sam)
    end

    it "should not include users who are not coworkers" do
      john = Factory(:user)
      Factory(:employment, :employee => john)
      @joe.coworkers.should_not include(john)
    end
  end

  context "feed reading" do
    it "should return false when there are no feeds in the preferences" do
      @user = Factory(:user)
      @feed = Factory(:feed, :featured => true)
      @user.chosen_feeds.should be_false
    end
  end

  context "admin messages" do
    before(:each) do
      @user = Factory(:user)
      Factory(:admin_message, :type => 'Admin::Announcement')
      @announcement = Admin::Announcement.first
    end

    it "should have all announcements" do
      @user.announcements.should == [@announcement]
    end
  end
  
  context "updating replies after confirmed" do
    
    it "should mark message replies as read for recently confirmed user" do
      user = Factory(:user, :confirmed_at => nil)
      user.expects(:mark_replies_as_read)
      user.confirm!
    end   
  end
  
  context "primary employment" do
    
    it "should choose the user's first employment as the primary employment if not otherwise specified" do
      user = Factory(:user)
      user.restaurants << Factory(:restaurant)
      user.primary_employment.should == user.employments.first
      user.restaurants.count.should == 1
    end
  end
end
