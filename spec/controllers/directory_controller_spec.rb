require_relative '../spec_helper'

describe DirectoryController do

  before(:each) do
    current_user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(current_user)
    FactoryGirl.create(:published_user); FactoryGirl.create(:published_user)
    FactoryGirl.create(:restaurant); FactoryGirl.create(:restaurant)
  end

  it "should show a list of all visible users" do
    get :index
    assigns[:users].count.should == User.in_spoonfeed_directory.count
  end

  it "should show a list of all activated restaurants" do
    FactoryGirl.create(:restaurant, :is_activated=> false);FactoryGirl.create(:restaurant, :is_activated=> true)
    get :restaurants
    assigns[:restaurants].count.should == Restaurant.activated_restaurant.count
  end

end