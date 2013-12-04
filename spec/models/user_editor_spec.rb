require_relative '../spec_helper'

describe UserEditor do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :editor_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    UserEditor.create!(@valid_attributes)
  end
end

