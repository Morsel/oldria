require_relative '../spec_helper'

describe CalendarsController do

  it "should have an index with events" do
    fake_normal_user
    restaurant = FactoryGirl.create(:restaurant)
    restaurant.employees << @user
    FactoryGirl.create(:event, :restaurant => restaurant)
    get :index, :restaurant_id => restaurant.id
    assigns[:events].to_a.should == restaurant.events
  end

end
