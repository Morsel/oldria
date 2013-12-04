require_relative '../spec_helper'

describe PressReleasesController do


  describe "GET 'index'" do
    it "should be successful" do
      user = Factory(:user)
      restaurant = Factory(:restaurant, :manager => user)
      controller.stubs(:current_user).returns(user)

      get 'index', :restaurant_id => restaurant.id
      response.should be_success
    end
  end
end
