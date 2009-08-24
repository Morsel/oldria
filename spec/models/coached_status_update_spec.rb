require File.dirname(__FILE__) + '/../spec_helper'

describe CoachedStatusUpdate do
  it "should be valid" do
    CoachedStatusUpdate.new.should be_valid
  end
end
