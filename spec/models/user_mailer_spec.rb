require 'spec/spec_helper'

describe UserMailer do
  include ActionController::UrlWriter

  default_url_options[:host] = DEFAULT_HOST

  describe "media request notifications" do
    before(:all) do
      @sender = Factory.stub(:media_user, :email => "media@media.com")
      @receiver = Factory.stub(:user, :name => "Hambone Fisher", :email => "hammy@spammy.com")
      @restaurant = Factory.stub(:restaurant)
      @employment = Factory.stub(:employment, :employee => @receiver, :restaurant => @restaurant)
      @request = Factory.stub(:media_request, :sender => @sender, :publication => "New York Times")
      @request_discussion = Factory.stub(:media_request_discussion, :media_request => @request, :restaurant => @restaurant)
      @email = UserMailer.create_media_request_notification(@request, @request_discussion)
    end

    xit "should be set to be delivered to the email passed in" do
      @email.should deliver_to("hammy@spammy.com")
    end

    it "should contain the media requests's publication name in the mail body" do
      @email.should have_text(/writer from New York Times/)
    end

    it "should contain a link to the media request conversation" do
      @email.should have_text(/#{media_request_discussion_url(@request_discussion)}/)
    end

    it "should have the correct subject" do
      @email.should have_subject(/#{@request.publication_string}/)
    end
  end

  describe "restaurant employee invitations" do
    before(:each) do
      @restaurant = Factory.stub(:restaurant, :name => "Joe's Place")
      @receiver = Factory(:user, :name => "Hambone Johnson", :email => "hambone@example.com", :username => "hambone")
      @receiver.stubs(:restaurants).returns([@restaurant])
      @email = UserMailer.create_employee_invitation(@receiver)
    end

    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("hambone@example.com")
    end

    it "should contain the media requests's publication name in the mail body" do
      @email.should have_text(/Joe's Place/)
    end

    it "should contain a link to the media request conversation" do
      @email.should have_text(/#{invitation_url(@receiver.perishable_token)}/)
    end
  end
end