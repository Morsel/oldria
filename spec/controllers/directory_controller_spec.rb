require_relative '../spec_helper'

describe DirectoryController do

  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns(current_user)
    Factory(:published_user); Factory(:published_user)
    Factory(:restaurant); Factory(:restaurant)
  end

  it "should show a list of all visible users" do
    get :index
    assigns[:users].count.should == User.in_spoonfeed_directory.count
  end

  it "should show a list of all activated restaurants" do
    Factory(:restaurant, :is_activated=> false);Factory(:restaurant, :is_activated=> true)
    get :restaurants
    assigns[:restaurants].count.should == Restaurant.activated_restaurant.count
  end

end