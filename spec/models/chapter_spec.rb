require 'spec_helper'

describe Chapter do
  before(:each) do
    @valid_attributes = {
      Factory.attributes_for(:chapter)
    }
  end

  it "should create a new instance given valid attributes" do
    Chapter.create!(@valid_attributes)
  end
end
