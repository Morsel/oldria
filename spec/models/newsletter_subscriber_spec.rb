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
end
