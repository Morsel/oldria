require 'spec_helper'

describe ChapterQuestionMembership do
  before(:each) do
    @valid_attributes = {
      :chapter_id => 1,
      :profile_question_id => 1,
      :position => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ChapterQuestionMembership.create!(@valid_attributes)
  end
end
