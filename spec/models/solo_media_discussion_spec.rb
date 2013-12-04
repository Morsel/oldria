require_relative '../spec_helper'

describe SoloMediaDiscussion do
  before(:each) do
    @valid_attributes = {
      :media_request_id => 1,
      :employment_id => 1,
      :comments_count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    SoloMediaDiscussion.create!(@valid_attributes)
  end
end

