require File.dirname(__FILE__) + '/../spec_helper'

describe Following do
  it "should be valid" do
    Following.new.should be_valid
  end
end
