require_relative '../spec_helper'

describe QuestionRole do
  before(:each) do
    @valid_attributes = {
      :profile_question_id => 1,
      :restaurant_role_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    QuestionRole.create!(@valid_attributes)
  end
end

