require_relative '../spec_helper'

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:profile_question, :chapter => Factory(:chapter))
  end

  should_belong_to :chapter

  it "should create a new instance given valid attributes" do
    ProfileQuestion.create!(@valid_attributes)
  end

  it "should have a topic" do
    Factory(:profile_question).topic.should_not be_nil
  end

  it "should be able to tell whether a user has answered it" do
    user = Factory(:user)
    question = Factory(:profile_question)
    question.answered_by?(user).should be_false
    Factory(:profile_answer, :user => user, :profile_question => question)
  end

end


