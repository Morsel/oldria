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
end