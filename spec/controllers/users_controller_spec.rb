require_relative '../spec_helper'

describe UsersController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all user as @user" do
      get :index
      @request.env['HTTP_ACCEPT'] = 'text/javascript'
    end
  end

  describe "GET show" do
    it "show" do
      get :show,:id=>@user.id
      response.should render_template(:show)
    end
  end

  describe "GET resume" do
    it "resume" do
      get :resume,:id=>@user.id
      response.should render_template(:resume)
    end
  end

  describe "GET edit" do
    it "edit" do
      get :edit,:id=>@user.id
      response.should redirect_to(edit_user_profile_path(:user_id => @user.id))
    end
  end

  describe "GET confirm" do
    it "confirm" do
      get :confirm,:id=>@user.id
      flash[:notice].should_not be_nil
      response.should redirect_to(root_path)
    end
  end

end
