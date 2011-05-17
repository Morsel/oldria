require 'spec_helper'

describe PromotionsController do

  it "should create a new promotion" do
    restaurant = Factory(:restaurant)
    post :create, :restaurant_id => restaurant.id,
        :promotion => Factory.attributes_for(:promotion, :promotion_type => Factory(:promotion_type))
    response.should be_redirect
    restaurant.promotions.count.should == 1
  end

end
