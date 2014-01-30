require_relative '../spec_helper'

describe CookbooksController do
  #integrate_views

  before(:each) do
    @cookbook = FactoryGirl.create(:cookbook)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end


  it "edit action should render edit template" do
    get :edit, :id => Cookbook.first
    response.should render_template(:edit)
  end

  it "create action should redirect when model is valid" do
    Cookbook.any_instance.stubs(:valid?).returns(true)
    post :create,:user_id=>@user.id
    response.header['Content-Type'].should include 'text/html'
  end

  it "create action should render new template when model is invalid" do
    Cookbook.any_instance.stubs(:valid?).returns(false)
    post :create,:user_id=>@user.id
    response.should render_template(:new)
  end




end

