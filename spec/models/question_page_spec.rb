require_relative '../spec_helper'

describe QuestionPage do
  it { should belong_to(:restaurant_question) }
  it { should belong_to(:restaurant_feature_page) }	
  
  before(:each) do
    @valid_attributes = {
      :restaurant_question_id => 1,
      :restaurant_feature_page_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    QuestionPage.create!(@valid_attributes)
  end
end

