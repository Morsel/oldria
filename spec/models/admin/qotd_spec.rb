require 'spec/spec_helper'

describe Admin::Qotd do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:qotd)
  end

  it "should create a new instance given valid attributes" do
    Admin::Qotd.create!(@valid_attributes)
  end
end