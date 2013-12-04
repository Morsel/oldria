require_relative '../spec_helper'

describe MetropolitanArea do
  should_have_many :restaurants

  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    MetropolitanArea.create!(@valid_attributes)
  end
end

