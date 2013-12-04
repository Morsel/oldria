require_relative '../spec_helper'

describe ProfileHelper do
  include ProfileHelper

  describe "#date_range" do
    before do
      @start_date = Date.parse('2010-02-01')
      @end_date   = 2.days.ago.to_date
      @object     = stub('object', :date_started => @start_date, :date_ended => @end_date)
    end

    it "should return a formatted string of the dates" do
      date_range(@object).should =~ /^Feb 2010 - /
    end

    it "should return 'Date - Present' when the end_date is nil" do
      @object.stubs(:date_ended).returns(nil)
      date_range(@object).should == "Feb 2010 - Present"
    end
  end
end