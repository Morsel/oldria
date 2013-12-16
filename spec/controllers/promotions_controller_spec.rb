require_relative '../spec_helper'

describe PromotionsController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
    controller.stubs(:current_user).returns(@user)
  end

  it "should create a new promotion" do
    promotion_type = FactoryGirl.create(:promotion_type)
    promotion = FactoryGirl.attributes_for(:promotion)
    promotion[:promotion_type_id] = promotion_type.id

    post :create, :restaurant_id => @restaurant.id,
        :promotion => promotion
    response.should be_redirect
    @restaurant.promotions.count.should == 1
  end

end
