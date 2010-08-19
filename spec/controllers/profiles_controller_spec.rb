require 'spec_helper'

describe ProfilesController do
  integrate_views
  before(:each) do
    fake_normal_user
    profile = Factory(:profile, :user => @user)
    @user.stubs(:profile).returns(profile)
  end

  it "edit action should render edit template" do
    get :edit
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Profile.any_instance.stubs(:valid?).returns(false)
    put :update
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Profile.any_instance.stubs(:valid?).returns(true)
    put :update
    response.should redirect_to( edit_my_profile_path )
  end
  
  it "should set the primary employment" do
    employment = Factory(:employment, :employee => @user)
    employment2 = Factory(:employment, :employee => @user)
    put :update, :profile => { :primary_employment => [employment2.id.to_s] }
    @user.primary_employment.should == employment2
  end
  
  it "should clear an old primary employment" do
    employment = Factory(:employment, :employee => @user)
    employment2 = Factory(:employment, :employee => @user, :primary => true)
    put :update, :profile => { :primary_employment => [employment.id.to_s] }
    @user.primary_employment.should == employment
    Employment.find(employment2.id).primary.should == false
  end
end
