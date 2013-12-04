require_relative '../spec_helper'

describe Event do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:event)
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
  
  it "should be required to have a status if it's a private event" do
    params = Factory.attributes_for(:event, :category => "Private")
    event = Event.create(params)
    event.should have(1).error_on(:status)
  end
  
  it "should be required to have a location" do
    params = Factory.attributes_for(:event, :category => "Holiday", :location => nil)
    event = Event.create(params)
    event.should have(1).error_on(:location)
  end
  
  it "shouldn't be required to have a location if it's an admin event" do
    params = Factory.attributes_for(:event, :category => "admin_holiday", :location => nil)
    event = Event.create(params)
    event.should have(0).errors_on(:location)
  end
end
