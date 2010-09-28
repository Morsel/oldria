require 'spec/spec_helper'

describe CompleteRegistrationsController do
  integrate_views
  before do
    fake_normal_user
    User.stubs(:find).returns(Factory(:user))
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
      User.any_instance.stubs(:valid?).returns(true)
      User.any_instance.stubs(:employments).returns([Factory(:employment)])
      put :update, :user => { :id => 1 }
      response.should redirect_to(root_path)
    end

  end
end
