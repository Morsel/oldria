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
  it { should have_many(:trace_keywords) }
  it { should have_many(:inverse_followings).class_name('Following').with_foreign_key('friend_id').dependent(:destroy)  }
  it { should have_many(:followers).through(:inverse_followings) }
  it { should have_many(:direct_messages).with_foreign_key('receiver_id').dependent(:destroy) }  
  it { should have_many(:sent_direct_messages).with_foreign_key('sender_id').dependent(:destroy) } 
  it { should have_many(:media_requests).with_foreign_key("sender_id") }
  it { should have_many(:restaurants).through(:employments) }
  it { should have_many(:managed_restaurants).class_name('Restaurant').with_foreign_key("manager_id") }
  it { should have_many(:restaurant_roles).through(:employments) } 
  it { should have_one(:default_employment).with_foreign_key('employee_id').dependent(:destroy) }
  it { should have_many(:all_employments).class_name('Employment').with_foreign_key('employee_id') }
  it { should have_many(:all_restaurant_roles).through(:all_employments) }
  it { should have_many(:discussion_seats).dependent(:destroy) }  
  it { should have_many(:discussions).through(:discussion_seats) } 
  it { should have_many(:posted_discussions).class_name('Discussion').with_foreign_key('poster_id') }
  it { should have_many(:admin_conversations).class_name('Admin::Conversation').with_foreign_key('recipient_id') }  
  it { should have_many(:solo_discussions).through(:default_employment).dependent(:destroy) }
  it { should have_many(:feed_subscriptions).dependent(:destroy) }  
  it { should have_many(:feeds).through(:feed_subscriptions) }  
  it { should have_many(:feeds).through(:feed_subscriptions) } 
  it { should have_many(:readings).dependent(:destroy) }  
  it { should have_many(:comments).dependent(:destroy) }  
  it { should have_one(:profile).dependent(:destroy) }  
  it { should have_many(:profile_answers).dependent(:destroy) } 
  it { should have_one(:invitation).with_foreign_key('invitee_id') }
  it { should have_many(:user_editors).dependent(:destroy) }
  it { should have_many(:editors).through(:user_editors) } 
  it { should have_one(:featured_profile) }
  it { should have_many(:restaurant_employee_requests).with_foreign_key('employee_id') }
  it { should have_many(:requested_restaurants).through(:restaurant_employee_requests) }    
  it { should have_one(:push_notification_user) }  
  it { should have_many(:user_restaurant_visitors) }
  it { should have_and_belong_to_many(:metropolitan_areas) }  
  it { should have_many(:media_newsletter_subscriptions).with_foreign_key('media_newsletter_subscriber_id').dependent(:destroy) }  
  it { should have_many(:user_profile_subscribers).with_foreign_key('profile_subscriber_id').dependent(:destroy) }  
  it { should have_many(:page_views).dependent(:destroy) }
  it { should accept_nested_attributes_for(:profile) }  
  it { should accept_nested_attributes_for(:default_employment) } 
  it do
   should_not allow_value('/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i').
     for(:email).
     with_message('is not a valid email address')
  end
  it { should validate_acceptance_of(:agree_to_contract) }
  it { should have_attached_file(:avatar) }
  it { should validate_attachment_content_type(:avatar).allowing("image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png") }
  it { should validate_acceptance_of(:agree_to_contract) }
  # it { should validate_presence_of(:facebook_page_token) }  
  # it { should validate_presence_of(:facebook_page_id) }  
  it { should have_one(:newsletter_subscriber) }
  it { should have_one(:media_newsletter_setting) }  
  it { should have_one(:user_visitor_email_setting) }  
  it { should accept_nested_attributes_for(:media_newsletter_setting) }
  it { should accept_nested_attributes_for(:user_visitor_email_setting) }
  it { should have_and_belong_to_many(:newsfeed_metropolitan_areas).class_name('MetropolitanArea') }  
  it { should accept_nested_attributes_for(:newsfeed_metropolitan_areas) }
  it { should belong_to(:newsfeed_writer) }
  it { should belong_to(:digest_writer) }
  it { should have_many(:metropolitan_areas_writers) }
  it { should have_many(:regional_writers) }
  it { should have_many(:promotion_types) }

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

  describe "#admin?" do
    it "return admin?" do
      user = FactoryGirl.create(:user)
      user.admin?.should == user.has_role?(:admin)
    end
  end

  describe "#media?" do
    it "return media?" do
      user = FactoryGirl.create(:user)
      user.media?.should == user.has_role?(:media)
    end
  end

  describe "#has_chef_role?" do
    it "return has_chef_role?" do
      user = FactoryGirl.create(:user)
      user.has_chef_role?.should == !(user.has_role?(:admin) || user.has_role?(:diner) || user.has_role?(:media))
    end
  end

  describe "#admin" do
    it "return admin" do
      user = FactoryGirl.create(:user)
      user.admin.should == TRUE_VALUES.include?(0) ? user.has_role!("admin") : user.has_no_role!(:admin)
    end
  end

  describe "#media" do
    it "return media" do
      user = FactoryGirl.create(:user)
      user.media.should == TRUE_VALUES.include?(0) ? user.has_role!("media") : user.has_no_role!(:media)
    end
  end

  describe "#has_role?" do
    it "return has_role?" do
      user = FactoryGirl.create(:user)
      user.has_role?("media").should == TRUE_VALUES.include?(0) ? user.has_role!("media") : user.has_no_role!(:media)
    end
  end

  describe "#has_role!" do
    it "return has_role!" do
      user = FactoryGirl.create(:user)
      role = "media"
      user.has_role!("media").should == user.update_attribute(:role, role.to_s)
    end
  end

  describe "#has_no_role!" do
    it "return has_no_role!" do
      user = FactoryGirl.create(:user)
      user.has_no_role!(role = nil).should ==  user.update_attribute(:role, nil)
    end
  end

  describe ".find_premium" do
    it "return find_premium" do
      user = FactoryGirl.create(:user)
      possibility = User.find_by_id(user.id)
      User.find_premium(user.id).should == if possibility.premium_account then possibility else nil end
    end
  end

  describe "#restaurants_where_manager" do
    it "return restaurants_where_manager" do
      user = FactoryGirl.create(:user)
      user.restaurants_where_manager.should == [user.managed_restaurants.all, user.manager_restaurants.all].compact.flatten.uniq
    end
  end

  describe "#allowed_subject_matters" do
    it "return allowed_subject_matters" do
      user = FactoryGirl.create(:user)
      allsubjects = SubjectMatter.all
      user.admin? ? allsubjects : allsubjects.reject(&:admin_only?)
    end
  end

  describe "#coworkers" do
    it "return coworkers" do
      user = FactoryGirl.create(:user)
      coworker_ids = user.restaurants.map(&:employee_ids).flatten.uniq
      user.coworkers.should ==  User.find(coworker_ids)
    end
  end

  describe "#primary_employment" do
    it "return primary_employment" do
      user = FactoryGirl.create(:user)
      user.employments.primary.first || user.employments.first || user.default_employment || user.employments
    end
  end  

  describe "#nonprimary_employments" do
    it "return nonprimary_employments" do
      user = FactoryGirl.create(:user)
      user.nonprimary_employments.should ==  user.employments - [user.primary_employment]
    end
  end  

  describe "#btl_enabled?" do
    it "return btl_enabled?" do
      user = FactoryGirl.create(:user)
      user.primary_employment.present? && user.primary_employment.restaurant_role.present?
    end
  end 

  describe "#to_label" do
    it "return to_label" do
      user = FactoryGirl.create(:user)
      user.to_label.should ==  user.name_or_username
    end
  end

  describe "#confirmed?" do
    it "return confirmed?" do
      user = FactoryGirl.create(:user)
      user.confirmed?.should ==  user.confirmed_at.present?
    end
  end

  describe "#confirm!" do
    it "return confirm!" do
      user = FactoryGirl.create(:user)
      user.confirmed_at = Time.now
      user.save
    end
  end

  describe "#completed_setup?" do
    it "return completed_setup?" do
      user = FactoryGirl.create(:user)
      user.completed_setup?.should ==  user.profile.present? && user.primary_employment.present?
    end
  end

  describe "#has_feeds?" do
    it "return has_feeds?" do
      user = FactoryGirl.create(:user)
      user.has_feeds?.should ==  !user.feeds.blank?
    end
  end  

  describe "#chosen_feeds" do
    it "return chosen_feeds" do
      user = FactoryGirl.create(:user)
      user.chosen_feeds(dashboard = false).should ==  !user.feeds.all(:limit => (dashboard ? 2 : nil)) if user.has_feeds?
    end
  end    

  describe "#export_columns" do
    it "return export_columns" do
      user = FactoryGirl.create(:user)
      user.export_columns(format = nil).should ==  %w[username first_name last_name email]
    end
  end  

  describe ".in_soapbox_directory" do
    it "return in_soapbox_directory" do
      user = FactoryGirl.create(:user)
      User.in_soapbox_directory.should ==  User.active.visible.with_premium_account.with_published_profile.by_last_name
    end
  end

  describe ".in_spoonfeed_directory" do
    it "return in_spoonfeed_directory" do
      user = FactoryGirl.create(:user)
      User.in_spoonfeed_directory.should ==  User.active.visible.by_last_name
    end
  end

  describe "#email_for_content" do
    it "return in_spoonfeed_directory" do
      user = FactoryGirl.create(:user)
      user.notification_email.present? ? user.notification_email : user.email
    end
  end  
  
  describe "#build_media_from_registration" do
    it "return build_media_from_registration" do
      new_user = FactoryGirl.create(:user,:first_name => "test",
                        :last_name => "test last",
                        :email => "testggggg.2302@email.com",
                        :role => "media")
     new_user.username = [new_user.first_name, new_user.last_name].join("")
      new_user.password = new_user.password_confirmation = Authlogic::Random.friendly_token  
    end
  end

  describe "#connect_to_facebook_user" do
    it "return connect_to_facebook_user" do
      user = FactoryGirl.create(:user)
      user.connect_to_facebook_user('100000679552330', '2023-08-31 12:16:55').should ==  user.update_attributes(:facebook_id => '100000679552330', :facebook_token_expiration => '2023-08-31 12:16:55')
    end   
  end   

  describe "#facebook_authorized?" do
    it "return facebook_authorized?" do
      user = FactoryGirl.create(:user)
      user.facebook_authorized?.should == user.facebook_id.present? and user.facebook_access_token.present?
    end   
  end   

  describe "#facebook_user" do
    it "return facebook_user" do
      user = FactoryGirl.create(:user)
      if user.facebook_id and user.facebook_access_token
        @facebook_user ||= Mogli::User.new(:id => user.facebook_id, :client => Mogli::Client.new(user.facebook_access_token))
      end
      user.facebook_user.should == @facebook_user
    end   
  end   

  describe "#profile_questions" do
    it "return profile_questions" do
      user = FactoryGirl.create(:user)
      if user.primary_employment.present? 
        profile_questions = ProfileQuestion.for_user(user) 
      else
        profile_questions =  []
      end   
     user.profile_questions.should == profile_questions 
    end   
  end  
  
  describe "#topics" do
    it "return topics" do
      user = FactoryGirl.create(:user)
      if user.primary_employment.present? 
        topics = Topic.for_user(user) 
      else
        topics = []
      end 
      user.topics.should == topics  
    end   
  end  

  describe "#published_topics" do
    it "return published_topics" do
      user = FactoryGirl.create(:user)
      user.published_topics.should == user.topics.select { |t| t.published?(user) }
    end   
  end  

  describe "#topics_without_travel" do
    it "return topics_without_travel" do
      user = FactoryGirl.create(:user)
      if user.primary_employment.present? 
      topics_without_travel = Topic.for_user(user).without_travel 
      else
      topics_without_travel = []
      end   
      user.topics_without_travel.should == topics_without_travel
    end  
  end 
    
  describe "#published_topics_without_travel" do
    it "return published_topics_without_travel" do
      user = FactoryGirl.create(:user)
      user.published_topics_without_travel.should == user.topics_without_travel.select { |t| t.published?(user) }
    end   
  end    

  describe "#cuisines" do
    it "return cuisines" do
      user = FactoryGirl.create(:user)
      if user.profile.present? 
      cuisines =  user.profile.cuisines 
      else 
      cuisines =  []
      end   
      user.cuisines.should == cuisines
    end   
  end    

  describe "#specialties" do
    it "return specialties" do
      user = FactoryGirl.create(:user)
      if user.profile.present? 
       specialties = user.profile.specialties 
      else
       specialties =  []
      end  
      user.specialties.should == specialties
    end   
  end    

  describe "#james_beard_region" do
    it "return james_beard_region" do
      user = FactoryGirl.create(:user)
      if user.profile.present? 
        james_beard_region = user.profile.james_beard_region 
      else  
       james_beard_region =  nil
     end 
     user.james_beard_region.should == james_beard_region
    end   
  end    

  describe "#metropolitan_area" do
    it "return metropolitan_area" do
      user = FactoryGirl.create(:user)
      if user.profile.present? 
      metropolitan_area =  user.profile.metropolitan_area
      else
      metropolitan_area =  nil
      end   
      user.metropolitan_area.should == metropolitan_area
    end   
  end    

  describe "#phone_number" do
    it "return phone_number" do
      user = FactoryGirl.create(:user)
      if user.profile.present? 
        phone_number = user.profile.cellnumber 
      else 
        phone_number = nil
      end   
       user.phone_number.should == phone_number
    end   
  end    

  describe "#public_phone_number" do
    it "return public_phone_number" do
      user = FactoryGirl.create(:user)
      if user.profile.blank? || !user.profile.display_cell_public?
       public_phone_number = nil
      else
       public_phone_number = user.profile.cellnumber  
      end   
      user.public_phone_number.should == public_phone_number
    end   
  end    

  describe "#linkable_profile?" do
    it "return linkable_profile?" do
      user = FactoryGirl.create(:user)
      if user.publish_profile? && user.premium_account?
        linkable_profile = true
      else
        linkable_profile = false  
      end   
    end    
  end  

  describe "#braintree_contact?" do
    it "return braintree_contact?" do
      user = FactoryGirl.create(:user)
       user.braintree_contact.should == user 
    end    
  end  

  describe "#recently_upgraded?" do
    it "return recently_upgraded?" do
      user = FactoryGirl.create(:user)
      user.recently_upgraded?.should == user.subscription.try(:start_date).try(:>, 1.week.ago.to_date) 
    end    
  end    
  
  describe "#individual?" do
    it "return individual?" do
      user = FactoryGirl.create(:user)
      user.individual?.should == user.employments.blank?
    end    
  end    
  
  describe "#has_restaurant_role?" do
    it "return has_restaurant_role?" do
      user = FactoryGirl.create(:user)
      user.has_restaurant_role?.should == !user.employments.first(:conditions => 'restaurant_role_id IS NOT NULL').nil?
    end    
  end    

  describe "#primary_restaurant?" do
    it "return primary_restaurant?" do
      user = FactoryGirl.create(:user)
      user.primary_restaurant?.should == user.primary_employment.present? 
    end    
  end    
    
  describe "#primary_restaurant" do
    it "return primary_restaurant" do
      user = FactoryGirl.create(:user)
      if user.primary_restaurant?
       primary_restaurant =  primary_employment.restaurant   
      else 
       primary_restaurant = nil 
      end  
      user.primary_restaurant.should == primary_restaurant
    end    
  end    

  describe "#get_employee_requests" do
    it "return get_employee_requests" do
      user = FactoryGirl.create(:user)
      user.get_employee_requests.should == RestaurantEmployeeRequest.find(:all,:conditions=>["restaurant_id in (?) and deleted_at is null ",user.restaurants.map(&:id)])#all(:select=>"restaurants.id")])
    end    
  end    

  describe "#update_newsletter_subscriber" do
    it "return update_newsletter_subscriber" do
      user = FactoryGirl.create(:user)
      user.update_newsletter_subscriber.should == user.newsletter_subscriber.update_from_user(user)
    end    
  end 

  describe "#restaurant_newsletter_subscription" do
    it "return restaurant_newsletter_subscription" do
      user = FactoryGirl.create(:user)
      restaurant = FactoryGirl.create(:restaurant)
      user.restaurant_newsletter_subscription(restaurant).should == user.media_newsletter_subscriptions.find_by_restaurant_id(restaurant.id)
    end    
  end 

  describe "#user_profile_subscribe" do
    it "return user_profile_subscribe" do
      user = FactoryGirl.create(:user)
      user.user_profile_subscribe(user).should == user.user_profile_subscribers.find_by_user_id(user.id)
    end    
  end 

  describe "#delete_other_writers" do
    it "return delete_other_writers" do
      user = FactoryGirl.create(:user)
      if user.newsfeed_writer_id == 1
        delete_other_writers = user.metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'NewsfeedWriter'").map(&:destroy)      
        delete_other_writers = user.regional_writers.find(:all,:conditions=>"regional_writer_type = 'NewsfeedWriter'").map(&:destroy)
      elsif user.newsfeed_writer_id == 2         
        delete_other_writers = user.metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'NewsfeedWriter'").map(&:destroy) 
      elsif user.newsfeed_writer_id == 3  
        delete_other_writers = user.regional_writers.find(:all,:conditions=>"regional_writer_type = 'NewsfeedWriter'").map(&:destroy)
      end 
      if user.digest_writer_id == 1
        delete_other_writers = user.metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestWriter'").map(&:destroy)      
        delete_other_writers = user.regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestWriter'").map(&:destroy)
      elsif user.digest_writer_id == 2  
        delete_other_writers = user.metropolitan_areas_writers.find(:all,:conditions=>"area_writer_type = 'DigestWriter'").map(&:destroy)      
      elsif  user.digest_writer_id == 3
        delete_other_writers = user.regional_writers.find(:all,:conditions=>"regional_writer_type = 'DigestWriter'").map(&:destroy)
      end 
      user.delete_other_writers.should == delete_other_writers
    end    
  end 

  describe "#get_digest_subscription" do
    it "return get_digest_subscription" do
      user = FactoryGirl.create(:user)
      digest_writer = FactoryGirl.create(:digest_writer)
      @restaurants = []
      if digest_writer.name == "National Writer"
        @restaurants = Restaurant.all
      elsif digest_writer.name == "Regional Writer"
        @restaurants = user.digest_writer.find_regional_writers(user).map(&:james_beard_region).map(&:restaurants)
      else
        @restaurants = user.digest_writer.find_metropolitan_areas_writers(user).map(&:metropolitan_area).map(&:restaurants)
      end 
      unless user.digest_writer.blank?
        @restaurants = @restaurants.flatten.compact.uniq
      end  
      user.get_digest_subscription.should == @restaurants
    end   
  end 


  describe "#send_employee_claim_notification_mail" do
    it "return send_employee_claim_notification_mail" do
      user1 = FactoryGirl.create(:user,:role=>"admin")
      user1 = FactoryGirl.create(:user,:role=>"admin")
      User.find(:all,:conditions=>["role=?",'admin']).each do |user|
        user.restaurants.each do |restaurant|
          restaurant.employees.find(:all,:conditions=>["role != 'admin' || role IS NULL AND confirmed_at IS NULL"]).each do |employee|
              if employee.claim_count <= 3
                employee.claim_count+=1
                employee.publication= "NULL" if employee.publication.blank?
                employee.save!
                UserMailer.send_employee_claim_notification_mail(user,employee,restaurant).deliver
              end   
          end   
        end   
      end   
    end
  end  

  describe ".build_media_user" do
    it "return build_media_user" do
    new_user =  FactoryGirl.create(:user,:first_name => "fname",
                        :last_name => "lname",
                        :email => "email.2302@gmail.com",
                        :username =>"username",
                        :publication => "publication",
                        :password => "12345678",
                        :password_confirmation => "12345678",
                        :is_imported =>true,
                        :confirmed_at => Time.now,
                        :role => "media")
    end
  end  


  describe " #digest_mailchimp_update" do
    it "return digest_mailchimp_update" do
    user = FactoryGirl.create(:user)
    signal = if user.media_newsletter_subscriptions.blank? && user.digest_writer.blank?
        "NO"
      else
        "YES"
      end 
       mc = MailchimpConnector.new("RIA Media") 
       mc.client.list_subscribe(:id => "1234", 
        :email_address => "email",
        :merge_vars => {:FNAME=>"first_name",
                        :LNAME=>"last_name",                        
                        :MYCHOICE=>"signal",                                              
        },:replace_interests => true,:update_existing=>true)    
    end
  end  

  describe " #send_newsletter_to_media_subscribers" do
    it "return send_newsletter_to_media_subscribers" do
    user = FactoryGirl.create(:user)
    #subscriber = FactoryGirl.create(:newsletter_subscriber)
      #if !user.subscriber.media_newsletter_setting.opt_out 
        begin
          mc = MailchimpConnector.new("RIA Media")
          campaign_id = \
          mc.client.campaign_create(:type => "regular",
                                  :options => { :list_id => mc.media_promotion_list_id,
                                                :subject => "RIA's Daily Dineline for #{Date.today.to_formatted_s(:long)}",
                                                :from_email => "hal@restaurantintelligenceagency.com",
                                                :to_name => "*|FNAME|*",
                                                :from_name => "Restaurant Intelligence Agency",
                                                :generate_text => true },
                                   :segment_opts => { :match => "all",
                                                      :conditions => [{ :field => "email",:op => "eq",:value => "tst.2302@gmail.com"},{ :field => "MYCHOICE",:op => "eq",:value => 'YES'}]
                                                      },
                                  :content => { :url => "test" })
          mc.client.campaign_send_now(:cid => campaign_id)
        rescue Exception => e
          UserMailer.log_file("User : #{subscriber.name} Error: #{e.message}","Exception").deliver
        end    
      #end  
    end  
  end 

  describe ".media" do
    it "return media" do
      user = FactoryGirl.create(:user)
      User.media.should == User.find(:all,:conditions=>['role = ? ', 'media'])
    end  
  end 

  describe ".not_media" do
    it "return not_media" do
      user = FactoryGirl.create(:user)
      User.not_media.should == User.find(:all,:conditions=>['role != ? OR role IS NULL', "media"])
    end  
  end 

  describe ".admin" do
    it "return admin" do
      user = FactoryGirl.create(:user)
      User.admin.should == User.find(:all,:conditions=>['role = ? ', 'admin'])
    end  
  end 

  describe ".by_last_name" do
    it "return by_last_name" do
      user = FactoryGirl.create(:user)
      User.by_last_name.should == User.all(order: 'last_name ASC')
    end  
  end 

  describe ".active" do
    it "return active" do
      user = FactoryGirl.create(:user)
      User.active.should == User.find(:all,:conditions=>['last_request_at IS NOT NULL'])
    end  
  end 

  describe ".visible" do
    it "return visible" do
      user = FactoryGirl.create(:user)
      User.visible.should == User.find(:all,:conditions=>['visible = ? AND (role != ? OR role IS NULL)', true, 'media'])
    end  
  end 

  describe ".with_published_profile" do
    it "return with_published_profile" do
      user = FactoryGirl.create(:user)
      User.with_published_profile.should == User.find(:all,:conditions=>["publish_profile = ?", true])
    end  
  end 

  describe ".for_autocomplete" do
    it "return for_autocomplete" do
      user = FactoryGirl.create(:user)
      User.for_autocomplete.should == User.select("first_name, last_name").limit(15).order('last_name ASC')
    end  
  end 



end


