require_relative '../spec_helper'

describe User do
  it { should have_many(:statuses).dependent(:destroy) }
  it { should have_many(:followings).with_foreign_key('follower_id').dependent(:destroy) }
  it { should have_many(:media_requests).with_foreign_key('sender_id') }
  it { should have_many(:managed_restaurants).with_foreign_key("manager_id").class_name("Restaurant") }
  it { should have_many(:employments).with_foreign_key("employee_id") }
  it { should have_many(:restaurants).through(:employments) }
  it { should have_many(:discussion_seats) }
  it { should have_many(:discussions).through(:discussion_seats) }
  it { should have_many(:posted_discussions).class_name('Discussion').with_foreign_key('poster_id') }
  it { should have_many(:feed_subscriptions) }
  it { should have_many(:feeds).through(:feed_subscriptions) }
  it { should have_many(:comments) }

  it { should validate_presence_of(:email) }
  it { should validate_acceptance_of(:agree_to_contract) }

  it "should be valid" do
    FactoryGirl.create(:user, :username => 'normal_user',:email=>"normal@normal.com").should be_valid
  end

  it "should allow a contractual virtual attribute" do
    user = FactoryGirl.create(:user,:email=>"riazzzzzzzz@riatest.com")
    user.agree_to_contract = true
  end

  it "should only allow alphanumeric characters in username" do
    user = FactoryGirl.build(:user, :username => nil)
    user.username = "chef*bacle"
    user.should_not be_valid
  end

  it "should handle #name" do
    u = FactoryGirl.build(:user, :first_name => "Ten", :last_name => "Davis" )
    u.name.should eql("Ten Davis")
  end

  describe "#name=()" do
    it "should save the name" do
      u = FactoryGirl.build(:user, :first_name => '', :last_name => '')
      u.name = "Ben Davis"
      u.save
      u.first_name.should eql("Ben")
      u.last_name.should eql("Davis")
    end

    it "should save the name for two names only" do
      u = FactoryGirl.create(:user,:email=>"Ten@Davis.com", :first_name => '', :last_name => '')
      u.name = "Ten Davis Smith"
      u.save
      u.first_name.should eql("Ten")
      u.last_name.should eql("Davis Smith")
    end

    it "should handle hyphenated names" do
      u = FactoryGirl.create(:user,:email=>"Ben@Davis.com", :first_name => '', :last_name => '')
      u.name = "Ben zDavis-Smith"
      u.save
      u.first_name.should eql("Ben")
      u.last_name.should eql("zDavis-Smith")
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
      @johnny = FactoryGirl.create(:user, :first_name => "Johnny", :last_name => "Walker",:email=>"johny@johny.com")
      @john   = FactoryGirl.create(:user, :first_name => "John", :last_name => "Deckerss",:email=>"Paul@johny.com")
      @amy    = FactoryGirl.create(:user, :first_name => "Amy", :last_name => "Jeckson",:email=>"Amy@johny.com")
    end

    it "should allow searching both columns simultaneously" do
      users = User.find_all_by_name("Johnny Walker")
      users.should include(@johnny)
      users.should_not include(@john)
    end

    it "should allow searching using only last name" do
      users = User.find_all_by_name("Walker")
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

    it "should be able to find all by name for autocompletion" do
      john = FactoryGirl.create(:user, :first_name => "Johnny", :last_name => "Dokers",:email=>"Johnny@Dokers.com" )
      joe = FactoryGirl.create(:user, :first_name => "Joe", :last_name => "Dokers",:email=>"Joe@Dokers.com"  )
      found = User.find_all_by_name("Jo Do")
      found.should include(john)
      found.should include(joe)
    end

    it "should handle multiple space-separated first or last names" do
      mary_anne = FactoryGirl.create(:user, :first_name => "Mary Anne", :last_name => "Thygesen",:email=>"mary@anne.com")
      users = User.find_all_by_name("Mary Anne Thygesen")
      users.should include(mary_anne)
      laura = FactoryGirl.create(:user, :first_name => "Laura", :last_name => "Windt Collins",:email=>"laura@Collins.com")
      users = User.find_all_by_name("Laura Windt Collins")
      users.should include(laura)
    end
  end

  context "searching with find_by_name" do

    it "should be able to find by name" do
      user = FactoryGirl.create(:user, :first_name => "Hamburg", :last_name => "Erlang",:email=>"Hamburg@Erlang.com" )
      User.find_by_name("Hamburg Erlang").should eql(user)
    end

    it "should handle multiple space-separated first or last names" do
      mary_anne = FactoryGirl.create(:user, :first_name => "Mary Anne", :last_name => "Thygesen",:email=>"Mary@Thygesen.com")
      User.find_by_name("Mary Anne Thygesen").should eql(mary_anne)
      laura = FactoryGirl.create(:user, :first_name => "Michel", :last_name => "Collins",:email=>"Michel@Collins.com")
      User.find_by_name("Michel Collins").should eql(laura)   
    end
  end

  context "following" do
    it "should know if he/she is following a user" do
      guy  = FactoryGirl.create(:user, :username => 'guy',:email=>"guy@Collins.com")
      girl = FactoryGirl.create(:user, :username => 'girl',:email=>"girl@Collins.com")
      guy.friends << girl
      guy.should be_following(girl)
    end
  end

  context "twitter and oauth" do
    before(:each) do
      @user = User.new(:atoken => 'atoken', :asecret => 'asecret')
      @twitter_client = Twitter::Client.new
      @user.stubs(:twitter_client).returns(@twitter_client)
      @tweet = JSON.parse( File.new(File.dirname(__FILE__) + '/../fixtures/twitter_update.json').read )
    end

    it "authorize from access token and secret" do
      @user.twitter_client.should_not be_nil
    end

    it "should retrieve friend requests" do
      @twitter_client.stubs(:friends_timeline).returns(@tweet)
      @user.twitter_client.friends_timeline.first['text'].should eql("Best American flag etiquette video series I've seen all month!  http://bit.ly/eiOZe")
    end

    it "should find twitter username when it's available" do
      @twitter_client.stubs(:user).returns({'screen_name' => 'twitter_username'})
      @user.twitter_username.should == "twitter_username"
    end

    it "should return nil when twitter username isn't available" do
      @twitter_client.stubs(:user).returns(nil)
      @user.twitter_username.should be_nil
    end

    it "should return nil when twitter returns blank" do
      @twitter_client.stubs(:user).returns([])
      @user.twitter_username.should be_nil
    end
  end

  context "who are media" do
    before(:each) do
      @user = FactoryGirl.create(:media_user,:email=>"email@email.com")
    end

    it "should have many (sent) media_requests" do
      MediaRequest.destroy_all
      @user.media_requests.should == []
    end
  end

  # context "non-media" do
  #   before do
  #     @restaurant = FactoryGirl.build(:restaurant,:name=>"restuarntzaaaaaaazzzz testzzz")
  #     @user = FactoryGirl.build(:user)
  #     @employment = FactoryGirl.build(:employment, :employee => @user, :restaurant => @restaurant, :omniscient => true)
  #   end

  #   it "should be able to see media requests" do
  #     search = EmploymentSearch.new(:conditions => {:restaurant_id_is => "#{@restaurant.id}"})
  #     request = FactoryGirl.build(:media_request, :employment_search => search, :status => "approved")
  #     discussion = request.discussion_with_restaurant(@restaurant)
  #     @user.viewable_media_request_discussions.should == [discussion]
  #   end
  # end

  # context "sending invitations" do
  #   it "should send from UserMailer" do
  #     user = FactoryGirl.build_stubbed(:user)
  #     user.send_invitation = true
  #     UserMailer.expects(:deliver_new_user_invitation!).returns(true)
  #     user.deliver_invitation_message!
  #     user.send_invitation.should be_nil
  #   end
  # end

  context "allowed subject matters" do
    before(:each) do
      @normal_subject = FactoryGirl.create(:subject_matter, :name => "Beer")
      @special_subject = FactoryGirl.create(:subject_matter, :name => "Admin (RIA)")
    end

    it "should include all but admin_only by default" do
      user = FactoryGirl.build_stubbed(:user)
      user.allowed_subject_matters.should include(@normal_subject)
    end

    it "should include all for admins" do
      user = FactoryGirl.create(:admin,:email=>"admin@email.com")
      user.allowed_subject_matters.should include(@normal_subject)
      user.allowed_subject_matters.should include(@special_subject)
    end
  end

  context "coworkers" do
    before do
      @restaurant = FactoryGirl.build_stubbed(:restaurant)
      @joe = FactoryGirl.create(:user)
      @sam = FactoryGirl.create(:user)
      FactoryGirl.create(:employment, :employee => @joe, :restaurant => @restaurant)
      FactoryGirl.create(:employment, :employee => @sam, :restaurant => @restaurant)
    end

    it "should be a list of users that work at any of the same restaurants" do
      @restaurant.employees.should include(@sam)
    end

    # it "should not include users who are not coworkers" do
    #   john = FactoryGirl.create(:user,:email=>"coworkers@coworkers.com")
    #   profile = FactoryGirl.create(:profile,:user=>john)
    #   FactoryGirl.create(:employment, :employee => john)
    #   @restaurant.employees.should_not include(john)
    # end
  end

  context "feed reading" do
    it "should return false when there are no feeds in the preferences" do
      @user = FactoryGirl.create(:user)
      @feed = FactoryGirl.create(:feed, :featured => true)
      @user.chosen_feeds.should be_false
    end
  end

  context "admin messages" do
    before(:each) do
      @user = FactoryGirl.build_stubbed(:user)
      FactoryGirl.create(:admin_message, :type => 'Admin::Announcement')
      @announcement = Admin::Announcement.first
    end

    it "should have all announcements" do
      @user.announcements.last.should == @announcement
      # @user.announcements.should == [@announcement]
    end
  end

  context "primary employment" do

    it "should choose the user's first employment as the primary employment if not otherwise specified" do
      user = FactoryGirl.build_stubbed(:user)
      user.restaurants << FactoryGirl.build_stubbed(:restaurant)
      user.primary_employment.should == user.employments.first
      user.restaurants.length.should == 1
    end

    # it "should allow a new primary employment to be set" do
    #   user = FactoryGirl.create(:user,:email=>"primary@primary.com")
    #   # profile = FactoryGirl.create(:profile,:user=>user)
    #   e1 = FactoryGirl.create(:employment, :employee => user)
    #   e2 = FactoryGirl.create(:employment, :employee => user, :primary => true)
    #   e3 = FactoryGirl.create(:employment, :employee => user)
    #   user.primary_employment.should == e2
    # end
  end

  describe "premium account" do

    it "finds a premium account" do
      user = FactoryGirl.create(:user,:email=>"premium@premium.com")
      user.subscription = FactoryGirl.create(:subscription, :payer => user)
      user.account_type.should == "Premium"
      User.find_premium(user.id).should == user
    end

    it "doesn't find a basic account" do
      user = FactoryGirl.create(:user,:email=>"basic@basic.com")
      user.account_type.should == "Basic"
      User.find_premium(user.id).should be_nil
    end

    it "finds a complimentary account" do
      user = FactoryGirl.create(:user,:email=>"account@account.com")
      user.subscription = FactoryGirl.create(:subscription, :payer => nil)
      user.account_type.should == "Complimentary Premium"
      User.find_premium(user.id).should == user
    end

  end

  describe "phone numbers" do
    let(:user) { FactoryGirl.create(:user) }


    it "returns nil if no profile" do
      user.phone_number.should be_nil
    end

    it "returns number if it exists" do
      profile = FactoryGirl.create(:profile, :user => user)
      user.phone_number.should == profile.cellnumber
    end

    it "handles public phone number" do
      profile = FactoryGirl.create(:profile, :user => user)
      user.public_phone_number.should == profile.cellnumber
    end

    it "handles private phone number" do
      profile = FactoryGirl.create(:profile, :user => user,
          :preferred_display_cell => "spoonfeed")
      user.public_phone_number.should be_nil
    end
  end

  describe "braintree_contact" do
    let(:user) { FactoryGirl.create(:user,:email=>"braintree@contact.com") }

    it "should return self" do
      user.braintree_contact == user
    end
  end

  # describe "find premiums via rspec" do

  #   before(:each) do |variable|
  #     @basic = FactoryGirl.create(:user, :name => "Basic",:email=>"basic@basic.com")
  #     @premium = FactoryGirl.create(:user, :name => "Premium",:email=>"premium@premium.com",
  #         :subscription => FactoryGirl.create(:subscription))
  #     @expired = FactoryGirl.create(:user, :name => "Expired",:email=>"expired@expired.com",
  #             :subscription => FactoryGirl.create(:subscription, :end_date => 1.month.ago))
  #     @overtime = FactoryGirl.create(:user, :name => "Overtime",:email=>"overtime@overtime.com",
  #             :subscription => FactoryGirl.create(:subscription, :end_date => 2.weeks.from_now))
  #   end

  #   it "finds the right users" do
  #     User.with_premium_account.all.should =~ [@premium, @overtime]
  #   end


  # end

  describe "extended_find" do
    it "find a user by last name" do
      user = FactoryGirl.create(:user,:email=>"alex@rose.com", :name => "Jerry Elevatson", :last_request_at => Time.now,
          :subscription => FactoryGirl.create(:subscription), :publish_profile => true)
      User.stubs(:in_soapbox_directory).returns(User)
      found = User.extended_find("vatson")
      found.should == [user]
    end
  end

end


