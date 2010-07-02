require 'spec_helper'

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
end
