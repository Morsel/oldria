require_relative '../../spec_helper'

describe Admin::PrTip do
  it "should set a class-based title of 'PR Tip'" do
    Admin::PrTip.title.should == "PR Tip"
  end
  
  it "should send the users an email notification when created" do
    user = FactoryGirl.create(:user, :prefers_receive_email_notifications => true)
    message = FactoryGirl.build(:pr_tip, :scheduled_at => Time.now)
    UserMailer.message_notification(message, user)
    message.save
  end

  describe "#broadcast?" do
    it "should return broadcast?" do
      pr_tip = FactoryGirl.create(:pr_tip)
      pr_tip.broadcast?.should == true
    end
  end 

  describe "#recipients_can_reply?" do
    it "should return recipients_can_reply?" do
      pr_tip = FactoryGirl.create(:pr_tip)
      pr_tip.recipients_can_reply?.should == false
    end
  end 


end


