require_relative '../spec_helper'

def soapbox?
  @is_soapbox
end

def current_user
  Factory(:user)
end

describe RestaurantsHelper do
  include RestaurantsHelper, ApplicationHelper, DirectoryHelper

  describe "restaurant link method" do
    it "should return restaurant link to spoonfeed" do
      restaurant = Factory(:restaurant)
      restaurant_link(restaurant).should == "<a href=\"/restaurants/#{restaurant.id}\">#{restaurant.name}</a>"
    end

    it "should show soapbox link when on soapbox if restaurant is premium" do
      @is_soapbox = true
      restaurant = Factory(:restaurant)
      restaurant.stubs(:premium_account?).returns(true)
      restaurant_link(restaurant).should == "<a href=\"/soapbox/restaurants/#{restaurant.id}\">#{restaurant.name}</a>"
    end

    it "should show just name w/o link when on soapbox if restaurant is not premium" do
      @is_soapbox = true
      restaurant = Factory(:restaurant)
      restaurant.stubs(:premium_account?).returns(false)
      restaurant_link(restaurant).should == "#{restaurant.name}"
    end
  end
end
