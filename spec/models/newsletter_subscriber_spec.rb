require 'spec_helper'

describe NewsletterSubscriber do
  before(:each) do
    @valid_attributes = {
      :email => "myemail@compy.com"
    }
  end

  it "should create a new instance given valid attributes" do
    NewsletterSubscriber.create!(@valid_attributes)
  end

  it "should send a confirmation email after creation" do
    subscriber = Factory(:newsletter_subscriber)
    UserMailer.expects(:send_later).with(:deliver_newsletter_subscription_confirmation, kind_of(NewsletterSubscriber))
    NewsletterSubscriber.create(@valid_attributes)
  end

end
