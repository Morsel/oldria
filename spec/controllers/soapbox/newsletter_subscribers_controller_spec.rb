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
      assigns[:subscriber].should have(2).errors_on(:email)
    end

  end
end
