require 'spec/spec_helper'

describe CompleteRegistrationsController do
  integrate_views
  before do
    fake_normal_user
    User.stubs(:find).returns(@user = Factory(:user))
  end

  describe "GET show" do
    it "should be successful" do
      get :show
      response.should render_template(:show)
    end
  end

  describe "PUT update" do
    
    it "should re-render the form when data is not valid" do
      User.any_instance.stubs(:valid?).returns(false)
      put :update, :user => { :id => 1 }
      response.should render_template(:show)
    end

    it "should redirect to the find restaurant page when data is valid and the user has no restaurants" do
      User.any_instance.stubs(:valid?).returns(true)
      put :update, :user => { :id => 1 }
      response.should redirect_to(find_restaurant_complete_registration_path)
    end

    it "should redirect to the dashboard when data is valid and the user has restaurants" do
      @user.stubs(:valid?).returns(true)
      @user.stubs(:primary_employment).returns(Factory(:employment, :employee => @user, 
          :restaurant => Factory(:managed_restaurant)))
      put :update, :user => { :id => 1 }
      response.should redirect_to(root_url)
    end

  end
  
  describe "finding and contacting one's employer" do

    it "should allow a user to search for their restaurant" do
      User.any_instance.stubs(:restaurants).returns([])
      
      restaurant = Factory(:restaurant, :name => "Some Pig")
      Restaurant.expects(:find).returns(restaurant.to_a)
      
      post :find_restaurant, :restaurant_name => restaurant.name
      assigns[:restaurants].should == [restaurant]
    end

    it "should allow a user to contact their restaurant to be added" do
      restaurant = Factory(:restaurant, :name => "Some Pig")
      UserMailer.expects(:deliver_employee_request).with(restaurant, controller.current_user).returns(true)
      post :contact_restaurant, :restaurant_id => restaurant.id
      response.should be_redirect
    end

  end
  
end
