require 'spec/spec_helper'

describe CloudmailsController do

  before(:each) do
    controller.stubs(:verify_cloudmail_signature).returns(true)

    @user = Factory(:user, :email => "reply-person@tester.com")
    User.stubs(:find).with('1').returns(@user)
    User.stubs(:find).with(1, {:readonly => nil, :include => nil, :select => nil, :conditions => nil}).returns(@user)
  end

  context "Successful emails" do

    before(:each) do
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

    it "should parse a valid Trend Question response from a restaurant employee" do
      restaurant = Factory.stub(:restaurant, :manager => @user)
      Factory.stub(:employment, :restaurant => restaurant)
      discussion = Factory(:admin_discussion,
      :restaurant => restaurant,
      :discussionable => Factory(:trend_question, :subject => "Trend to reply to"))
      AdminDiscussion.stubs(:find).returns(discussion)

      post :create, :to => "1-token-RD-1@dev-mailbot.restaurantintelligenceagency.com",
                    :message => "",
                    :plain => "This is my Trend Q reply\nRespond by replying to this email - above this line\nThis is the Trend message",
                    :signature => ""

      discussion.comments.count.should == 1
      discussion.comments.first.user.should == @user
    end

    it "should parse a valid Trend Question response from a solo employee" do
      employment = Factory.stub(:default_employment, :employee => @user)
      discussion = Factory(:solo_discussion,
      :employment => employment,
      :trend_question => Factory(:trend_question, :subject => "Another trend to reply to"))
      SoloDiscussion.stubs(:find).returns(discussion)

      post :create, :to => "1-token-SD-1@dev-mailbot.restaurantintelligenceagency.com",
                    :message => "",
                    :plain => "This is my Trend Q reply\nRespond by replying to this email - above this line\nThis is the Trend message",
                    :signature => ""

      discussion.comments.count.should == 1
      discussion.comments.first.user.should == @user
    end

  end

  it "should send an error to a user who tries to reply to an already-answered Trend Question for their main restaurant" do
    restaurant = Factory.stub(:restaurant, :manager => @user)
    discussion = Factory(:admin_discussion,
                         :restaurant => restaurant,
                         :discussionable => Factory(:trend_question, :subject => "Trend to reply to more than once"))
    AdminDiscussion.stubs(:find).returns(discussion)
    comment = Comment.create!(:commentable => discussion, :user => restaurant.media_contact, :title => "A previous comment")
    discussion.comments.count.should == 1

    post :create, :to => "1-token-RD-1@dev-mailbot.restaurantintelligenceagency.com",
                  :message => "",
                  :plain => "This is my Trend Q reply\nRespond by replying to this email - above this line\nThis is the Trend message",
                  :signature => ""

    discussion.comments.count.should == 1
  end

  it "should send an error to a user who removes the reply separator text" do
    conversation = Factory(:admin_conversation, :recipient => @user, :admin_message => Factory(:qotd))
    Admin::Conversation.stubs(:find).returns(conversation)

    post :create, :to => "1-token-QOTD-1@dev-mailbot.restaurantintelligenceagency.com",
                  :message => "",
                  :plain => "This is my QOTD reply - I deleted everything else",
                  :signature => ""

    conversation.comments.count.should == 0
  end

end
