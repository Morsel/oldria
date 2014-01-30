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

  it "should have ria" do
  	get :ria
  	response.should render_template(:action=> "index")
  end
 
end
