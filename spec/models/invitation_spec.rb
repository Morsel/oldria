require_relative '../spec_helper'

describe Invitation do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:invitation)
    @valid_attributes[:restaurant_role] = FactoryGirl.create(:restaurant_role)
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@valid_attributes)
  end
  
  describe "admin_invitation_notice and invitation_welcome" do
    let(:invitation){ FactoryGirl.create(:invitation) }
    
    it "should send admins an email after creation" do
      mail = UserMailer.admin_invitation_notice(invitation)
      mail.subject.should == "A new invitation has been requested"
      mail = UserMailer.invitation_welcome(invitation)
      mail.subject.should == "Spoonfeed Invitation Request Received"
      #UserMailer.expects(:invitation_welcome).returns(true)
      # Invitation.create!(@valid_attributes)
    end    
  end
end

