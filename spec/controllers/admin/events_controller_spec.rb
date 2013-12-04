require_relative '../spec_helper'

describe Admin::EventsController do

  before(:each) do
    fake_admin_user
  end

  it "should allow an admin to create a new event" do
    event_params = Factory.attributes_for(:admin_event)

    post :create, :event => event_params
    response.should be_redirect
    Event.count.should == 1
  end
  
  it "should allow an admin to update an event" do
    event = Factory(:admin_event)
    Event.stubs(:find).returns(event)
    event.expects(:update_attributes).with("title" => "New title").returns(true)
    put :update, :event => { :title => "New title" }, :id => event.id
    response.should be_redirect
  end
  
  it "should allow a user to delete an event" do
    event = Factory(:admin_event)
    Event.stubs(:find).returns(event)
    event.expects(:destroy)
    delete :destroy, :id => event.id
  end
end
