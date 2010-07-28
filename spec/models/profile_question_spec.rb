require 'spec_helper'

describe ProfileQuestion do
  before(:each) do
    @valid_attributes = {
      :topic_id => 1,
      :chapter_id => 1,
      :title => "value for title"
    }
  end

  it "should create a new instance given valid attributes" do
    ProfileQuestion.create!(@valid_attributes)
  end
end
