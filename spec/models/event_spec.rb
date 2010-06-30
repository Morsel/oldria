require 'spec_helper'

describe Event do
  before(:each) do
    @valid_attributes = {
      :restaurant_id => 1,
      :title => "value for title",
      :start_at => Time.now,
      :end_at => Time.now,
      :location => "value for location",
      :description => "value for description",
      :category => "value for category",
      :status => "value for status"
    }
  end

  it "should create a new instance given valid attributes" do
    Event.create!(@valid_attributes)
  end
end
