require 'spec_helper'

describe Competition do
  before(:each) do
    @valid_attributes = {
      :profile_id => 1,
      :name => "value for name",
      :place => "value for place",
      :year => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Competition.create!(@valid_attributes)
  end
end
