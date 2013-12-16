require_relative '../../spec_helper'

describe Mediafeed::MediafeedController do

  it "should send a request for information" do
    @sender = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(@sender)
    
    restaurant = FactoryGirl.create(:restaurant)
    UserMailer.expects(:message_notification)
    post :request_information, :user_id => restaurant.media_contact_id, :request_type => "Twitter", :request_title => "Twitter message here..."
    DirectMessage.count.should == 1
  end

end
