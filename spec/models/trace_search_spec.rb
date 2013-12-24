require_relative '../spec_helper'


describe TraceSearch do
	it { should belong_to :user }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:trace_search)
  end

  it "should create a new instance given valid attributes" do
    TraceSearch.create!(@valid_attributes)
  end

end 
  