require_relative '../spec_helper'

describe StatusesController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all statuses as @statuses" do
      User.stubs(:find).returns([@user])
      get :index ,:user_id => @user.id
      response.should render_template(:index)
    end
  end

  it "create action should render new template when model is invalid" do
    Status.any_instance.stubs(:valid?).returns(false)
    post :create,:user_id => @user.id
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Status.any_instance.stubs(:valid?).returns(true)
    post :create,:user_id => @user.id
    response.should redirect_to user_statuses_path(@user)
  end
end 
   

