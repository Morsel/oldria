require_relative '../spec_helper'

describe NewsletterSubscriber do
  before(:each) do
    @valid_attributes = {
      :email => "myemail@compy.com",
      :password => "secret",
      :password_confirmation => "secret"
    }
  end

  it "should create a new instance given valid attributes" do
    NewsletterSubscriber.create!(@valid_attributes)
  end

  it "should send a confirmation email after creation" do
    # UserMailer.expects(:send_later).with(:newsletter_subscription_confirmation, kind_of(NewsletterSubscriber))
    # NewsletterSubscriber.create(@valid_attributes)
    UserMailer.expects(:newsletter_subscription_confirmation).with(NewsletterSubscriber.create(@valid_attributes))
  end

end

