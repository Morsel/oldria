require_relative '../../spec_helper'

describe Admin::UsersController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all user as @user" do
      User.stubs(:find).returns([@user])
      get :index
      assigns[:users].should == [@user]
      response.should render_template(:index)
    end
  end

  it "show action should render show template" do
    get :show,:id=>@user.id
    response.should render_template(:show)
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      User.stubs(:new).returns(@user)
      get :new
      assigns[:user].should equal(@user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      User.stubs(:find).returns(@user)
      get :edit, :id => "37"
      assigns[:user].should equal(@user)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        User.stubs(:new).returns(@user)
        User.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created user as @user" do
        post :create, :user => {}
        assigns[:user].should equal(@user)
      end
  end

  describe "with invalid params" do
    before(:each) do
      User.any_instance.stubs(:save).returns(false)
      User.stubs(:new).returns(@user)
    end

    it "assigns a newly created but unsaved user as @user" do
      post :create, :user => {:these => 'params'}
      assigns[:user].should equal(@user)
    end

    it "re-renders the 'new' template" do
      post :create, :user => {}
      response.should render_template('new')
    end
  end
 end 

 describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        User.stubs(:find).returns(@user)
        User.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested user" do
        User.expects(:find).with("37").returns(@user)
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "assigns the requested user as @user" do
        User.stubs(:find).returns(@user)
        put :update, :id => "1"
        assigns[:user].should equal(@user)
      end

      it "redirects to all user" do
        User.stubs(:find).returns(@user)
        put :update, :id => "1"
        response.should redirect_to (admin_users_url)
      end
    end

    describe "with invalid params" do
      before(:each) do
        User.stubs(:find).returns(@user)
        User.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested user" do
        User.expects(:find).with("37").returns(@user)
        put :update, :id => "37", :user => {:these => 'params'}
      end

      it "assigns the user as @user" do
        put :update, :id => "1"
        assigns[:user].should equal(@user)
      end

      it "re-renders the 'edit' template" do
        User.stubs(:find).returns(@user)
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      @user.expects(:find).with("37").returns(@user)
      @user.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(admin_users_url)
    end
  end   

  describe "GET impersonator" do
    it "impersonator" do
      get :impersonator, :id => @user.id
      response.should redirect_to(root_path)
    end
  end   


end   