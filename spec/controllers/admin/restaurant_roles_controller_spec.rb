require_relative '../../spec_helper'

describe Admin::RestaurantRolesController do

  integrate_views

  before(:each) do
    @restaurant_role = FactoryGirl.create(:restaurant_role)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all restaurant_role as @restaurant_role" do
      RestaurantRole.stubs(:find).returns([@mediafeed_page])
      get :index
      assigns[:restaurant_roles].should == [@restaurant_role]
    end
  end

  describe "GET new" do
    it "assigns a new restaurant_role as @restaurant_role" do
      RestaurantRole.stubs(:new).returns(@restaurant_role)
      get :new
      assigns[:restaurant_role].should equal(@restaurant_role)
    end
  end

  describe "GET edit" do
    it "assigns the requested restaurant_role as @restaurant_role" do
      RestaurantRole.stubs(:find).returns(@restaurant_role)
      get :edit, :id => "37"
      assigns[:restaurant_role].should equal(@restaurant_role)
    end
  end
 
  describe "POST create" do

    describe "with valid params" do
      before(:each) do
        RestaurantRole.stubs(:new).returns(@restaurant_role)
        RestaurantRole.any_instance.stubs(:save).returns(true)
      end

      it "assigns a newly created restaurant_role as @restaurant_role" do
        post :create, :restaurant_role => {}
        assigns[:restaurant_role].should equal(@restaurant_role)
      end

      it "redirects to the created restaurant_role" do
        post :create, :restaurant_role => {}
        response.should redirect_to(redirect_to admin_restaurant_roles_path)
      end
    end

     describe "with invalid params" do
      before(:each) do
        RestaurantRole.any_instance.stubs(:save).returns(false)
        RestaurantRole.stubs(:new).returns(@restaurant_role)
      end

      it "assigns a newly created but unsaved restaurant_role as @restaurant_role" do
        post :create, :restaurant_role => {:these => 'params'}
        assigns[:restaurant_role].should equal(@restaurant_role)
      end

      it "re-renders the 'new' template" do
        post :create, :restaurant_role => {}
        response.should render_template('new')
      end
    end
  end 

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        RestaurantRole.stubs(:find).returns(@restaurant_role)
        RestaurantRole.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested restaurant_role" do
        RestaurantRole.expects(:find).with("37").returns(@restaurant_role)
        put :update, :id => "37", :restaurant_role => {:these => 'params'}
      end

      it "assigns the requested restaurant_role as @restaurant_role" do
        RestaurantRole.stubs(:find).returns(@restaurant_role)
        put :update, :id => "1"
        assigns[:restaurant_role].should equal(@restaurant_role)
      end

      it "redirects to all restaurant_role" do
        RestaurantRole.stubs(:find).returns(@restaurant_role)
        put :update, :id => "1"
        redirect_to admin_restaurant_roles_path
      end
    end

    describe "with invalid params" do
      before(:each) do
        RestaurantRole.stubs(:find).returns(@restaurant_role)
        RestaurantRole.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested restaurant_role" do
        RestaurantRole.expects(:find).with("37").returns(@restaurant_role)
        put :update, :id => "37", :restaurant_role => {:these => 'params'}
      end

      it "assigns the restaurant_role as @restaurant_role" do
        put :update, :id => "1"
        assigns[:restaurant_role].should equal(@restaurant_role)
      end

      it "re-renders the 'edit' template" do
        RestaurantRole.stubs(:find).returns(@restaurant_role)
        put :update, :id => "1"
        response.should render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested restaurant_role" do
      RestaurantRole.expects(:find).with("37").returns(@restaurant_role)
      @restaurant_role.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to admin_restaurant_roles_path
    end
  end   

  describe "update_category" do
    it "update_category " do
      RestaurantRole.expects(:find).with("37").returns(@restaurant_role)
      get :update_category, :role_id => "37"
      response.should redirect_to :action => :index
    end
  end 


end   