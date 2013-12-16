require_relative '../spec_helper'

describe EventsController do
  before(:each) do
    fake_normal_user
    @restaurant = FactoryGirl.create(:restaurant)
    @restaurant.employees << @user
  end

  it "should allow a user to create a new event" do
    event_params = FactoryGirl.attributes_for(:event)

    post :create, :event => event_params, :restaurant_id => @restaurant.id
    response.should be_redirect
    assigns[:restaurant].should == @restaurant
    @restaurant.events.count.should == 1
  end
  
  it "should allow a user to update an event" do
    event = FactoryGirl.create(:event, :restaurant => @restaurant)
    Event.stubs(:find).returns(event)
    event.expects(:update_attributes).with("title" => "New title").returns(true)
    put :update, :event => { :title => "New title" }, :id => event.id, :restaurant_id => @restaurant
    response.should be_redirect
  end
  
  it "should allow a user to delete an event" do
    event = FactoryGirl.create(:event, :restaurant => @restaurant)
    Event.stubs(:find).returns(event)
    event.expects(:destroy)
    delete :destroy, :id => event.id, :restaurant_id => @restaurant
  end
  
  it "should allow a restaurant user to transfer a RIA event to their calendar" do
    event = FactoryGirl.create(:admin_event)
    Event.stubs(:find).returns(event)
    Event.expects(:new).with(event.attributes).returns(event)
    post :transfer, :id => event.id, :restaurant_id => @restaurant
  end

end
