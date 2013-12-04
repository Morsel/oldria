require_relative '../../spec_helper'

describe Admin::Announcement do
  it "should set a class-based title of 'Announcement'" do
    Admin::Announcement.title.should == "Announcement"
  end

  it "should be considered a broadcast message" do
    Admin::Announcement.new.should be_broadcast
  end
  
  it "should send the users an email notification when created" do
    user = Factory(:user, :prefers_receive_email_notifications => true)
    message = Factory.build(:announcement, :scheduled_at => Time.now)
    UserMailer.expects(:send_at).with(message.scheduled_at, :deliver_message_notification, message, user)
    message.save
  end

end


