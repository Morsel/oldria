require 'spec_helper'

describe Award do
  should_belong_to :profile

  before(:each) do
    @valid_attributes = Factory.attributes_for(:award)
  end

  it "should create a new instance given valid attributes" do
    Award.create!(@valid_attributes)
  end
end

