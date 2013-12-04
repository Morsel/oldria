require_relative '../spec_helper'

describe Award do
  it { should belong_to :profile }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:award)
  end

  it "should create a new instance given valid attributes" do
    Award.create!(@valid_attributes)
  end
end

