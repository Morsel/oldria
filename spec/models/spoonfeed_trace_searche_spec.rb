require_relative '../spec_helper'

describe SpoonfeedTraceSearche do
	it { should belong_to :user }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:spoonfeed_trace_Searche)
  end

  it "should create a new instance given valid attributes" do
    SpoonfeedTraceSearche.create!(@valid_attributes)
  end
end 