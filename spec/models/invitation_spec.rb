require_relative '../spec_helper'

describe Invitation do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:invitation, :restaurant_role => Factory(:restaurant_role))
  end

  it "should create a new instance given valid attributes" do
    Invitation.create!(@valid_attributes)
  end
  
  it "should send admins an email after creation" do
    UserMailer.expects(:deliver_admin_invitation_notice).returns(true)
    Invitation.create!(@valid_attributes)
  end
end

