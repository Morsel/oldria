require 'spec/spec_helper'
 
describe RestaurantsController do
  integrate_views

  before(:each) do
    @user = Factory(:user)
    controller.stubs(:current_user).returns(@user)
  end

  context "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end
    
    it "should assign @restaurant" do
      get :new
      assigns[:restaurant].should be_a(Restaurant)
    end
    
    it "should build restaurant through current_user" do
      get :new
      assigns[:restaurant].manager.should == @user
    end
  end

  context "POST create" do
    it "should build restaurant through current_user" do
      post :create, :restaurant => {}
      assigns[:restaurant].manager.should == @user
    end
    
    it "should render new template when model is invalid" do
      Restaurant.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end
  
    it "should redirect when model is valid" do
      Restaurant.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(restaurant_employees_path(assigns[:restaurant]))
    end
  end
end
