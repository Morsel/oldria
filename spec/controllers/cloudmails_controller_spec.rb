require 'spec/spec_helper'

describe CloudmailsController do

  before(:each) do
    # controller.expects(:verify_cloudmail_signature).returns(true)

    @user = Factory(:user)
    User.stubs(:find).returns(@user)
    @user.expects(:validate_cloudmail_token!).returns(true)
  end

  it "should parse a valid QOTD response" do
    conversation = Factory(:admin_conversation, :recipient => @user, :admin_message => Factory(:qotd))
    Admin::Conversation.stubs(:find).returns(conversation)

    post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
                  :message => "",
                  :plain => "This is my QOTD reply\nRespond by replying to this email - above this line\nThis is the QOTD message",
                  :signature => ""

    conversation.comments.count.should == 1
    conversation.comments.first.user.should == @user
  end

  it "should parse a valid BTL response" do
    question = Factory(:profile_question)
    ProfileQuestion.stubs(:find).returns(question)

    post :create, :to => "1-token-BTL-1@dev-mailbot.restaurantintelligenceagency.com",
                  :message => "",
                  :plain => "This is my BTL reply\nRespond by replying to this email - above this line\nThis is the BTL message",
                  :signature => ""

    question.profile_answers.count.should == 1
    question.profile_answers.first.user.should == @user
  end

  it "should parse a valid Trend Question response"

end
