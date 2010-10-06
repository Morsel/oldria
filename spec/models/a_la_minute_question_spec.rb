require 'spec_helper'

describe ALaMinuteQuestion do
  before(:each) do
    @valid_attributes = {
      :question => "value for question",
      :type => "value for type"
    }
  end

  it "should create a new instance given valid attributes" do
    ALaMinuteQuestion.create!(@valid_attributes)
  end

  it "should correctly identify restaurant types" do
    restaurant = Factory(:a_la_minute_question, :kind => :restaurant)
    user = Factory(:a_la_minute_question, :kind => :user)
    ALaMinuteQuestion.restaurants.all.should == [restaurant]
  end
end
