require_relative '../spec_helper'

describe PasswordResetsController do

  it "should reset a password for a user when valid email is provided" do
    user = Factory(:user)
    User.stubs(:find_by_email).returns(user)
    user.expects(:deliver_password_reset_instructions!)
    post :create, :email => user.email
  end
  
  it "should not send the password reset email when a user attempts to reset an unconfirmed account" do
    user = Factory(:user, :confirmed_at => nil)
    User.stubs(:find_by_email).returns(user)
    user.expects(:deliver_password_reset_instructions!).never
    post :create, :email => user.email
  end

end