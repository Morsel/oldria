require_relative '../spec_helper'

describe PressReleasesController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @restaurant = FactoryGirl.create(:restaurant)
    @press = FactoryGirl.build(:press_release,:restaurant_id=>@restaurant_id)
	  @press.save(:validate => false)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end


  describe "GET 'index'" do
    it "should be successful" do
      user = FactoryGirl.create(:user)
      restaurant = FactoryGirl.create(:restaurant, :manager => user)
      controller.stubs(:current_user).returns(user)
      get 'index', :restaurant_id => restaurant.id
      response.should be_success
    end
  end

  it "create action should render new template when model is invalid" do
    PressRelease.any_instance.stubs(:valid?).returns(false)
    post :create,:restaurant_id=>@restaurant.id
    response.should render_template(:action=> "edit")
  end 

  it "create action should redirect when model is valid" do
	  PressRelease.any_instance.stubs(:valid?).returns(true)
	  post :create,:restaurant_id=>@restaurant.id
	  response.should redirect_to :action => :index,
                                 :restaurant_id => @restaurant.id
  end 

  it "edit action should render edit template" do
    get :edit, :id => @press.id,:restaurant_id => @restaurant.id
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    PressRelease.any_instance.stubs(:valid?).returns(false)
    put :update, :id => PressRelease.first, :restaurant_id => @restaurant.id
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    PressRelease.any_instance.stubs(:valid?).returns(true)
    put :update, :id => PressRelease.first, :restaurant_id => @restaurant.id
    response.should redirect_to :action => :index,
                                 :restaurant_id => @restaurant.id
  end

  it "archive" do
    get :archive, :restaurant_id => @restaurant.id
    response.should render_template(:archive)
  end  

end
