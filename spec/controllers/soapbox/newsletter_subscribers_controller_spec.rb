require 'spec_helper'

describe Soapbox::NewsletterSubscribersController do

  describe "POST 'create'" do
    it "should create a new subscriber when an email address is given" do
      post 'create', :newsletter_subscriber => { :email => "testemail@testdomain.com" }
      response.should be_redirect
      NewsletterSubscriber.count.should == 1
    end

    it "should not create a subscriber when no email address is present" do
      post 'create'
      response.should render_template('new')
      assigns[:subscriber].should have(1).error_on(:email)
    end

  end

  describe "GET 'confirm'" do
    it "should confirm a user when valid id and token are given" do
      subscriber = Factory(:newsletter_subscriber)
      NewsletterSubscriber.stubs(:find).returns(subscriber)
      get 'confirm', :id => 1, :token => subscriber.confirmation_token
      response.should be_success
      subscriber.reload.confirmed_at.should_not be_nil
    end

    it "should not confirm the user if no valid token is given" do
      subscriber = Factory(:newsletter_subscriber)
      NewsletterSubscriber.stubs(:find).returns(subscriber)
      get 'confirm', :id => 1
      response.should be_success
      subscriber.reload.confirmed_at.should be_nil
    end
  end

end
