require_relative '../spec_helper'

describe SfPromo do
  before(:each) do
    @valid_attributes = {
      :title => "My title",
      :body => "My description"
    }
  end

  it "should create a new instance given valid attributes" do
    SfPromo.create!(@valid_attributes)
  end
end

