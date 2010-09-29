require 'spec/spec_helper'

describe Admin::PrTip do
  it "should set a class-based title of 'PR Tip'" do
    Admin::PrTip.title.should == "PR Tip"
  end
  
  it "should send the users an email notification when created" do
    user = Factory(:user, :prefers_receive_email_notifications => true)
    message = Factory.build(:pr_tip, :scheduled_at => Time.now)
    UserMailer.expects(:send_at).with(message.scheduled_at, :deliver_message_notification, message, user)
    message.save
  end

end

# == Schema Information
#
# Table name: admin_messages
#
#  id              :integer         not null, primary key
#  type            :string(255)
#  scheduled_at    :datetime
#  status          :string(255)
#  message         :text
#  created_at      :datetime
#  updated_at      :datetime
#  holiday_id      :integer
#  display_message :string(255)
#

