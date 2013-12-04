require_relative '../spec_helper'

describe CalendarsController do

  it "should have an index with events" do
    fake_normal_user
    restaurant = Factory(:restaurant)
    restaurant.employees << @user
    Factory(:event, :restaurant => restaurant)
    get :index, :restaurant_id => restaurant.id
    assigns[:events].should == restaurant.events
  end

end
