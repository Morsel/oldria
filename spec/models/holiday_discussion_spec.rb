require_relative '../spec_helper'

describe HolidayDiscussion do
  before(:each) do
    @valid_attributes = {
      :restaurant_id => 1,
      :holiday_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    HolidayDiscussion.create!(@valid_attributes)
  end
end

