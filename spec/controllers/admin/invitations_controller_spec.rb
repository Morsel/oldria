require_relative '../../spec_helper'

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
    invite = FactoryGirl.create(:invitation)
    Invitation.stubs(:find).returns(invite)
    invite.expects(:update_attributes).with("title" => "Head Chef").returns(true)
    put :update, :id => invite.id, :invitation => { :title => "Head Chef" }
  end

  it "should delete an invite" do
    invite = FactoryGirl.create(:invitation)
    Invitation.stubs(:find).returns(invite)
    invite.expects(:destroy).returns(true)
    delete :destroy, :id => invite.id
  end
  
  it "should archive an invite" do
    invite = FactoryGirl.create(:invitation)
    Invitation.stubs(:find).returns(invite)
    invite.expects(:update_attribute).with(:archived, true).returns(true)
    post :archive, :id => invite.id
  end
    
  it "should resend work for if condition" do
    user = FactoryGirl.create(:user,:perishable_token=>'ddfff')
    invite = FactoryGirl.create(:invitation,:invitee_id=>user.id)
    get :resend,:id=>invite.id
    flash.should_not be_nil
    response.should redirect_to :action => :index,:archived => true
  end
  it "should resend work for else  condition" do
    invite = FactoryGirl.create(:invitation,:invitee_id=>@user.id)
    get :resend,:id=>invite.id
    flash.should_not be_nil
    response.should redirect_to :action => :index,:archived => true
  end

  describe "GET accept" do
    it "work for accept if invitee present" do
      user = FactoryGirl.create(:user,:perishable_token=>'ddfff')
      invite = FactoryGirl.create(:invitation,:invitee_id=>user.id)
      get :accept,:id=>invite.id
      get :accept
      flash.should_not be_nil
      response.should redirect_to :action => :index,:archived => "true"
    end
  end

end
