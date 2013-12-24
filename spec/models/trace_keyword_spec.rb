require_relative '../spec_helper'

describe TraceKeyword do
	it { should belong_to :keywordable }
	it { should belong_to :user }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:trace_keyword)
  end

  it "should create a new instance given valid attributes" do
    TraceKeyword.create!(@valid_attributes)
  end
end 