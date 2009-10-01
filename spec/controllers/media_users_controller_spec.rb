require File.dirname(__FILE__) + '/../spec_helper'
 
describe MediaUsersController do
  integrate_views
  
  before(:each) do
    @user = Factory(:media_user) 
  end
  
  describe "GET new" do
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end
    
    it "should render a form to /media_users" do
      get :new
      response.should have_selector("form", :action => "/media_users")
    end
  end

  describe "POST create" do
    it "create action should render new template when model is invalid" do
      User.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end
  
    it "create action should redirect when model is valid" do
      UserMailer.expects(:deliver_signup).returns true
      User.any_instance.stubs(:save).returns @user
      User.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(root_url)
    end
  end

  describe "GET edit" do
    it "edit action should render edit template" do
      get :edit, :id => User.first
      response.should render_template(:edit)
    end
  
    it "update action should render edit template when model is invalid" do
      User.any_instance.stubs(:valid?).returns(false)
      put :update, :id => User.first
      response.should render_template(:edit)
    end
  end

  describe "DELETE destroy" do
    it "update action should redirect when model is valid" do
      User.any_instance.stubs(:valid?).returns(true)
      put :update, :id => User.first
      response.should redirect_to(media_user_url(assigns[:media_user]))
    end
  end
end
