# == Schema Information
# Schema version: 20100303185000
#
# Table name: admin_messages
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  holiday_id   :integer
#

require 'spec/spec_helper'

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
