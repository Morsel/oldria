require 'spec_helper'

describe Enrollment do
  should_belong_to :profile
  should_belong_to :school

  before(:each) do
    @valid_attributes = Factory.attributes_for(:enrollment)
  end

  it "should create a new instance given valid attributes" do
    Factory.create(:enrollment)
  end
end
