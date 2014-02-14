require_relative '../spec_helper'

describe NonculinaryEnrollmentsController do
  integrate_views

  before(:each) do
    @user = current_user = FactoryGirl.create(:user)
    FactoryGirl.create(:profile, :user => @user)
    controller.stubs(:current_user).returns(current_user)
  end

   it "should build a new nonculinary job" do
    get :new, :user_id => @user.id
    response.should be_success
    assigns[:nonculinary_enrollment].should_not be_nil
  end  

   it "should create a new job" do
    job_params = FactoryGirl.attributes_for(:nonculinary_enrollment, :profile => @user.profile)
    post :create, :user_id => @user.id, :nonculinary_enrollment => job_params
    response.should be_success
  end

  it "should allow the user to edit a job" do
    job = FactoryGirl.create(:nonculinary_enrollment, :profile => @user.profile)
    get :edit, :user_id => @user.id, :id => job.id
    response.should be_success
  end

  it "should update a job" do
    job = FactoryGirl.create(:nonculinary_enrollment, :profile => @user.profile)
    put :update, :user_id => @user.id, :id => job.id
    response.should be_redirect
  end

  it "should delete a job" do
    job = FactoryGirl.create(:nonculinary_enrollment, :profile => @user.profile)
    NonculinaryEnrollment.count.should == 1
    delete :destroy, :user_id => @user.id, :id => job.id
    NonculinaryEnrollment.count.should == 0
  end
  
end
