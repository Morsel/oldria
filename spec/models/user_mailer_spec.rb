require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
  include ActionController::UrlWriter

  default_url_options[:host] = DEFAULT_HOST

  describe "media request notifications" do
    before(:all) do
      @sender = Factory.stub(:media_user, :email => "media@media.com", :publication => "New York Times")
      @receiver = Factory.stub(:user, :name => "Hambone Fisher", :email => "hammy@spammy.com")
      @request = Factory.stub(:media_request, :sender => @sender)
      @request_conversation = Factory.stub(:media_request_conversation, :media_request => @request, :recipient => @receiver)
      @email = UserMailer.create_media_request_notification(@request, @request_conversation)
    end

    it "should be set to be delivered to the email passed in" do
      @email.should deliver_to("hammy@spammy.com")
    end

    it "should contain the sender's publication name in the mail body" do
      @email.should have_text(/writer from New York Times/)
    end

    it "should contain a link to the media request conversation" do
      @email.should have_text(/#{media_request_conversation_url(@request_conversation)}/)
    end

    it "should have the correct subject" do
      @email.should have_subject(/#{@request.sender_publication_string}/)
    end
  end
end