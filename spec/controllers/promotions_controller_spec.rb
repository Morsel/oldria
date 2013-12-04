require_relative '../spec_helper'

describe PromotionsController do

  before(:each) do
    @user = Factory(:user)
    @restaurant = Factory(:restaurant, :manager => @user)
    controller.stubs(:current_user).returns(@user)
  end

  it "should create a new promotion" do
    post :create, :restaurant_id => @restaurant.id,
        :promotion => Factory.attributes_for(:promotion, :promotion_type => Factory(:promotion_type))
    response.should be_redirect
    @restaurant.promotions.count.should == 1
  end

end
