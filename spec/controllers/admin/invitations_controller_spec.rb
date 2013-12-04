require_relative '../spec_helper'

describe Admin::InvitationsController do

  before(:each) do
    fake_admin_user
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
  
  it "should update an invite" do
    invite = Factory(:invitation)
    Invitation.stubs(:find).returns(invite)
    invite.expects(:update_attributes).with("title" => "Head Chef").returns(true)
    put :update, :id => invite.id, :invitation => { :title => "Head Chef" }
  end

  it "should delete an invite" do
    invite = Factory(:invitation)
    Invitation.stubs(:find).returns(invite)
    invite.expects(:destroy).returns(true)
    delete :destroy, :id => invite.id
  end
  
  it "should archive an invite" do
    invite = Factory(:invitation)
    Invitation.stubs(:find).returns(invite)
    invite.expects(:update_attribute).with(:archived, true).returns(true)
    post :archive, :id => invite.id
  end
    
end
