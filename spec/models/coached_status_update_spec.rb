require File.dirname(__FILE__) + '/../spec_helper'

describe CoachedStatusUpdate do
  it "should be valid" do
    CoachedStatusUpdate.new.should be_valid
  end
end

describe CoachedStatusUpdate, "date ranges" do
  before(:each) do
    @christmas = Factory(:date_range, :start_date => Date.parse('2009-12-01'), :end_date => Date.parse('2009-12-26'))
    @summer = Factory(:date_range, :start_date => Date.parse('2009-06-20'), :end_date => Date.parse('2009-09-20'))
    Date.stubs(:today).returns(Date.parse('2009-08-01'))
  end
  
  it "should return current messages" do
    summer_message = Factory(:coached_status_update, :date_range => @summer)
    CoachedStatusUpdate.current.should include(summer_message)
  end
  
  it "should not return message out of the date range" do
    christmas_message = Factory(:coached_status_update, :date_range => @christmas)
    CoachedStatusUpdate.current.should_not include(christmas_message)
  end
end