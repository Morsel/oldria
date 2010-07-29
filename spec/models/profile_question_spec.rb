require 'spec_helper'

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:profile_question, :chapter => Factory(:chapter))
  end

  it "should create a new instance given valid attributes" do
    ProfileQuestion.create!(@valid_attributes)
  end
  
  it "should have a chapter" do
    Factory(:profile_question).chapter.should_not be_nil
  end

  it "should have a topic" do
    Factory(:profile_question).topic.should_not be_nil
  end    

end
