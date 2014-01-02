require_relative '../spec_helper'

describe DateRange do
it { should have_many(:coached_status_updates) }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:date_range)
  end

  it "should create a new instance given valid attributes" do
    DateRange.create!(@valid_attributes)
  end
end	

