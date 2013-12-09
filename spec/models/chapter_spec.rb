require_relative '../spec_helper'

describe Chapter do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:chapter)
    @valid_attributes[:topic] = FactoryGirl.create(:topic)
  end

  it "should create a new instance given valid attributes" do
    Chapter.create!(@valid_attributes)
  end
  
  it "should have many questions" do
    FactoryGirl.create(:chapter).profile_questions.should be_a_kind_of(Array)
  end
  
  it "should have a topic" do
    FactoryGirl.create(:chapter).topic.should_not be_nil
  end
end

