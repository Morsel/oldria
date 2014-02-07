require_relative '../../spec_helper'

describe Admin::RestaurantsController do

  integrate_views

  before(:each) do
    @restaurant = FactoryGirl.create(:restaurant)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all restaurant as @restaurant" do
      Restaurant.stubs(:find).returns([@restaurant])
      get :index
      assigns[:restaurants].should == [@restaurant]
    end
  end

  describe "PUT update" do

    describe "with valid params" do
      before(:each) do
        Restaurant.stubs(:find).returns(@restaurant)
        Restaurant.any_instance.stubs(:update_attributes).returns(true)
      end

      it "updates the requested restaurant" do
        Restaurant.expects(:find).with("37").returns(@restaurant)
        put :update, :id => "37", :restaurant => {:these => 'params'}
      end

      it "assigns the requested restaurant as @restaurant" do
        Restaurant.stubs(:find).returns(@restaurant)
        put :update, :id => "1"
        assigns[:restaurant].should equal(@restaurant)
      end

      it "redirects to all restaurant" do
        Restaurant.stubs(:find).returns(@restaurant)
        put :update, :id => "1"
        response.should redirect_to admin_restaurants_path
      end
    end

    describe "with invalid params" do
      before(:each) do
        Restaurant.stubs(:find).returns(@restaurant)
        Restaurant.any_instance.stubs(:update_attributes).returns(false)
      end

      it "updates the requested restaurant" do
        Restaurant.expects(:find).with("37").returns(@restaurant)
        put :update, :id => "37", :restaurant => {:these => 'params'}
      end

      it "assigns the restaurant as @restaurant" do
        put :update, :id => "1"
        assigns[:restaurant].should equal(@restaurant)
      end

      it "re-renders the 'edit' template" do
        Restaurant.stubs(:find).returns(@restaurant)
        put :update, :id => "1"
        response.should render_template(:action=> "edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested restaurant" do
      Restaurant.expects(:find).with("37").returns(@restaurant)
      @restaurant.expects(:destroy)
      delete :destroy, :id => "37"
      response.should redirect_to(admin_restaurants_path)
    end
  end

  describe "invalid_employments" do
    it "invalid_employments" do
      get :invalid_employments, :id => @restaurant.id
      response.should render_template(:invalid_employments)
    end
  end

  describe "select_primary_photo" do
    it "select_primary_photo" do
      get :select_primary_photo, :id => @restaurant.id
      response.should be_success
    end
  end

 
end
