require_relative '../spec_helper'

describe SoapboxTraceKeyword do
	it { should belong_to :keywordable }
	it { should belong_to :restaurant }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:soapbox_trace_keyword)
  end

  it "should create a new instance given valid attributes" do
    SoapboxTraceKeyword.create!(@valid_attributes)
  end
end 