require_relative '../spec_helper'

describe RestaurantFeaturesController do

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @page = FactoryGirl.create(:restaurant_feature_page)
     FactoryGirl.create(:restaurant_feature)
     FactoryGirl.create(:restaurant_feature)
     FactoryGirl.create(:restaurant_feature)
     FactoryGirl.create(:restaurant_feature)
    @restaurant = FactoryGirl.create(:restaurant)
    Restaurant.stubs(:find => @restaurant)
  end

  # describe "put create" do

  #   it "passes values to the restaurant and displays back to the bulk edit" do
  #     # @restaurant.expects(:reset_features).with([1, 2, 3, 4], [])
  #     put :add, :features => [1, 2, 3, 4], :restaurant_id => @restaurant.id, :id => @page.id
  #     response.should redirect_to(bulk_edit_restaurant_feature_path(@restaurant, @page))
  #   end

  # end
  
  # describe "updating top tags" do
    
  #   it "should update the new top restaurant features for the restaurant" do
  #     i1 = FactoryGirl.create(:restaurant_feature_item, :restaurant => @restaurant)
  #     i2 = FactoryGirl.create(:restaurant_feature_item, :restaurant => @restaurant)
  #     post :update_top, :restaurant_id => @restaurant.id, :restaurant_features => [i2.restaurant_feature.id.to_s]
  #     i1.restaurant_feature.top_tag?(@restaurant).should == false
  #     i2.restaurant_feature.top_tag?(@restaurant).should == true
  #   end
  # end


end
