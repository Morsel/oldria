require 'spec_helper'

describe MenuItem do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :price => "value for price"
    }
  end

  it "should create a new instance given valid attributes" do
    MenuItem.create!(@valid_attributes)
  end
end
