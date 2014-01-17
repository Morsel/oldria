require_relative '../spec_helper'

describe UserMailer do
  include ActionView::Helpers::TextHelper  
  include ActionDispatch::Routing::UrlFor
  include Rails.application.routes.url_helpers

  default_url_options[:host] = DEFAULT_HOST

  describe "media request notifications" do
    before(:all) do
      #CIS mock_model / stub_model not available in before(:all) blocks? 
      #https://github.com/rspec/rspec-rails/issues/279 http://stackoverflow.com/questions/16583329/stub-method-in-factorygirl
      @sender = FactoryGirl.create(:media_user, :email => "media@media.com")
      @receiver = FactoryGirl.create(:user, :name => "Hambone Fisher", :email => "hammy@spammy.com")
      @restaurant = FactoryGirl.create(:restaurant, :name => "Bluefish")
      @employment = FactoryGirl.create(:employment, :employee => @receiver, :restaurant => @restaurant)
      @request = FactoryGirl.create(:media_request, :sender => @sender, :publication => "New York Times")
      @request_discussion = FactoryGirl.create(:media_request_discussion, :media_request => @request, :restaurant => @restaurant)
      @request_discussion.stubs(:employments).returns([@employment])
      @email = UserMailer.media_request_notification(@request_discussion, @receiver)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("hammy@spammy.com")
    end

    it "should contain the media requests's publication name in the mail body" do
      @email.subject.should include("from New York Times")
      # @email.should have_text(/from New York Times/)
    end

    it "should contain a link to the media request conversation" do
      @email.body.should include("#{media_request_discussion_url(@request_discussion)}")
      # @email.should have_text(/#{media_request_discussion_url(@request_discussion)}/)
    end

    it "should have the correct subject" do
      @email.should have_subject(/#{@request.publication_string}/)
    end
  end
  
  describe "media request notifications for solo users" do
    before(:all) do
      @sender = FactoryGirl.create(:media_user, :email => "media@mediamail.com")
      @receiver = FactoryGirl.create(:user, :name => "Hambone Fisher", :email => "hammy_dumpy@spammy.com")
      @employment = FactoryGirl.create(:employment, :employee => @receiver)
      @request = FactoryGirl.create(:media_request, :sender => @sender, :publication => "New York Times")
      @request_discussion = FactoryGirl.create(:solo_media_discussion, :media_request => @request, :employment => @employment)
      @request_discussion.stubs(:employments).returns([@employment])
      @email = UserMailer.media_request_notification(@request_discussion, @receiver)
    end
    it "should contain a link to the solo media conversation" do
      # @email.should have_text(/#{solo_media_discussion_url(@request_discussion)}/)
      @email.body.should include("#{solo_media_discussion_url(@request_discussion)}")
    end
  end

  describe "restaurant employee invitations" do
    before(:each) do
      @restaurant = FactoryGirl.create(:restaurant, :name => "Joe's Place")
      @receiver = FactoryGirl.create(:user, :name => "Hambone Johnson", :email => "hambone@example.com", :username => "hambone")
      @receiver.stubs(:restaurants).returns([@restaurant])
      @receiver.reset_perishable_token!
      @email = UserMailer.new_user_invitation!(@receiver)
    end

    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("hambone@example.com")
    end

    it "should contain a link to the invitation so the user can log in" do
      @email.body.should include("#{invitation_url(@receiver.perishable_token)}")
    end
  end

  describe "signup" do
    before(:each) do
      @user = FactoryGirl.create(:user,:perishable_token =>'Ht5bg3pW8pD6WZLZpxT')
      @email = UserMailer.signup(@user, Time.now)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Welcome to Spoonfeed! Please confirm your account/)
    end
  end

 describe "signup_for_soapbox" do
    before(:each) do
      @user = FactoryGirl.create(:user,:perishable_token =>'Ht5bg3pW8pD6WZLZpxT')
      @email = UserMailer.signup_for_soapbox(@user, Time.now)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Welcome to Soapbox! Please confirm your account/)
    end
  end

  describe "password_reset_instructions" do
    before(:each) do
      @user = FactoryGirl.create(:user,:perishable_token =>'Ht5bg3pW8pD6WZLZpxT')
      @email = UserMailer.password_reset_instructions(@user)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Spoonfeed: Password Reset Instructions/)
    end
    it "should have password_reset_url" do
      @email.body.encoded.should match(edit_password_reset_url(@user.perishable_token))
    end
  end

  describe "password_reset_instructions_for_soapbox" do
    before(:each) do
      @user = FactoryGirl.create(:user,:perishable_token =>'Ht5bg3pW8pD6WZLZpxT')
      @email = UserMailer.password_reset_instructions_for_soapbox(@user)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Soapbox: Password Reset Instructions/)
    end
    it "should have password_reset_url" do
      @email.body.encoded.should match(edit_soapbox_soapbox_password_reset_url(@user.perishable_token))
    end
  end

  describe "password_reset_instructions_for_soapbox" do
    before(:each) do
      @user = FactoryGirl.create(:user,:perishable_token =>'Ht5bg3pW8pD6WZLZpxT')
      @email = UserMailer.password_reset_instructions_for_soapbox(@user)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Soapbox: Password Reset Instructions/)
    end
    it "should have password_reset_url" do
      @email.body.encoded.should match(edit_soapbox_soapbox_password_reset_url(@user.perishable_token))
    end
  end  

  describe "discussion_notification" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @discussion = FactoryGirl.create(:discussion)
      @email = UserMailer.discussion_notification(@discussion,@user)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'notifications@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Spoonfeed: #{@discussion.poster.try :name} has invited you to a discussion/)
    end
  end    

  describe "signup_recommendation" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @user_email = @user.email
      @email = UserMailer.signup_recommendation(@user_email,@user)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user_email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'notifications@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Spoonfeed referral from #{@user.name}/)
    end
  end    

  describe "invitation_welcome" do
    before(:each) do
      @invite = FactoryGirl.create(:invitation)
      @email = UserMailer.invitation_welcome(@invite)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@invite.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'notifications@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Spoonfeed Invitation Request Received/)
    end
  end  


  describe "admin_invitation_notice" do
    before(:each) do
      @invite = FactoryGirl.create(:invitation)
      @email = UserMailer.admin_invitation_notice(@invite)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to('info@restaurantintelligenceagency.com')
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'notifications@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/A new invitation has been requested/)
    end
  end  

  describe "new_user_invitation!" do
    before(:each) do
      @invite = FactoryGirl.create(:invitation)
      @user = FactoryGirl.create(:user,:perishable_token =>'Ht5bg3pW8pD6WZLZpxT')
      @email = UserMailer.new_user_invitation!(@user,@invite)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@user.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Your invitation to Spoonfeed has arrived!/)
    end
  end 

  describe "employee_request" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @restaurant = FactoryGirl.create(:restaurant)
      @email = UserMailer.employee_request(@restaurant,@user)
    end
    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to(@restaurant.manager.email)
    end
    it "renders the sender email" do
      @email[:from].to_s.should == 'accounts@restaurantintelligenceagency.com'
    end
    it "should have subject" do
      @email.should have_subject(/Spoonfeed: a new employee has joined/)
    end
  end   

  # describe "message_notification" do
  #   before(:each) do
  #     @user = FactoryGirl.create(:user)
  #     @restaurant = FactoryGirl.create(:restaurant)
  #     @message = "test"
  #     @recipient = @restaurant.manager
  #     @sender = @user.email
  #     @email = UserMailer.message_notification(@message,@recipient,@sender)
  #   end
  #   it "should be set to be delivered to the email passed in" do
  #     @email.should deliver_to(@recipient.email)
  #   end
  #   it "renders the sender email" do
  #     @email[:from].to_s.should == 'notifications@restaurantintelligenceagency.com'
  #   end
  #   it "should have subject" do
  #     @email.should have_subject(/Spoonfeed: #{@message.try(:email_title)} notification/)
  #   end
  # end   


end