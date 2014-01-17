require_relative '../spec_helper'

describe UserEditor do
  it { should belong_to(:user) }
  it { should belong_to(:editor).class_name('User') }

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

