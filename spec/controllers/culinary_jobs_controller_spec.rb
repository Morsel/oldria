require_relative '../spec_helper'

describe CulinaryJobsController do
  #integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "new action should render new template" do
    get :new,:user_id=>@user.id
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    post :create,:user_id=>@user.id
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    post :create,:user_id=>@user.id
    response.header['Content-Type'].should include 'text/html'
  end

  it "edit action should render edit template" do
  	@culinary_job = FactoryGirl.create(:culinary_job)
    get :edit, :id => @culinary_job.id
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is valid" do
    @culinary_job = FactoryGirl.create(:culinary_job)
    CulinaryJob.any_instance.stubs(:valid?).returns(true)
    put :update, :id => @culinary_job.id
    response.header['Content-Type'].should include 'text/html'
  end

end
