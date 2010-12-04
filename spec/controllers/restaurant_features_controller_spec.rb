require 'spec/spec_helper'

describe RestaurantFeaturesController do

  before(:each) do
    @user = Factory(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @page = Factory(:restaurant_feature_page)
    @restaurant = Factory(:restaurant)
  end

  describe "put create" do

    it "passes values to the restaurant and displays back to the index" do
      Restaurant.stubs(:find => @restaurant)
      @restaurant.expects(:reset_features).with([1, 2, 3, 4], [])
      put :add, :features => [1, 2, 3, 4], :restaurant_id => @restaurant.id, :id => @page.id
      response.should redirect_to(restaurant_feature_path(@restaurant, @page))
    end

  end

end