require 'spec/spec_helper'

describe Admin::PrTip do
  it "should be valid" do
    Admin::PrTip.new.should be_valid
  end

  it "should set a class-based title of 'PR Tip'" do
    Admin::PrTip.title.should == "PR Tip"
  end
end
