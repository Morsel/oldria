require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
  include ActionController::UrlWriter

  default_url_options[:host] = DEFAULT_HOST

  describe "media request notifications" do
    before(:all) do
      @request = Factory.stub(:media_request)
      @receiver = Factory.stub(:user, :name => "Hambone Fisher", :email => "hammy@spammy.com")
      @sender = Factory.stub(:media_user, :email => "media@media.com", :publication => "New York Times")
      @request.stubs(:sender).returns(@sender)
      @request.stubs(:recipients).returns([@receiver])
      @email = UserMailer.create_media_request_notification(@request)
    end

    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("hammy@spammy.com")
    end

    it "should contain the sender's publication name in the mail body" do
      @email.should have_text(/writer from New York Times/)
    end

    it "should contain a link to login" do
      @email.should have_text(/#{login_url}/)
    end

    it "should have the correct subject" do
      @email.should have_subject(/You have a Media Request/)
    end
  end
end