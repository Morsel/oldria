require 'spec/spec_helper'

describe Admin::TrendQuestion do
  it "should inherit from Admin::Message" do
    Admin::TrendQuestion.new.should be_an(Admin::Message)
  end

  it "should set a class-based title of 'Seasonal/Trend Question'" do
    Admin::TrendQuestion.title.should == "Seasonal/Trend Question"
  end
end
