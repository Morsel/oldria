require_relative '../spec_helper'

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:profile_question)
    @valid_attributes[:chapter] = FactoryGirl.create(:chapter)
  end

  it { should belong_to :chapter }

  it "should create a new instance given valid attributes" do
    ProfileQuestion.create!(@valid_attributes)
  end

  it "should have a topic" do
    FactoryGirl.create(:profile_question).topic.should_not be_nil
  end

  it "should be able to tell whether a user has answered it" do
    user = FactoryGirl.create(:user)
    question = FactoryGirl.create(:profile_question)
    question.answered_by?(user).should be_false
    FactoryGirl.create(:profile_answer, :user => user, :profile_question => question)
  end

end


