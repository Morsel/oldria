require 'spec_helper'
describe RestaurantsHelper do
  include RestaurantsHelper
  describe "restaurant link method" do
    it "should return restaurant link to spoonfeed" do
      restaurant = Factory(:restaurant)
      restaurant_link(restaurant).should == "<a href=\"/restaurants/#{restaurant.id}\">#{restaurant.name}</a>"
    end

    it "should show soapbox link when on soapbox if restaurant is premium" do
      params[:controller] = "soapbox"
      restaurant = Factory(:restaurant)
      restaurant.stubs(:premium_account?).returns(true)
      restaurant_link(restaurant).should == "<a href=\"/soapbox/restaurants/#{restaurant.id}\">#{restaurant.name}</a>"
    end

    it "should show just name w/o link when on soapbox if restaurant is not premium" do
      params[:controller] = "soapbox"
      restaurant = Factory(:restaurant)
      restaurant.stubs(:premium_account?).returns(false)
      restaurant_link(restaurant).should == "#{restaurant.name}"
    end
  end
end
