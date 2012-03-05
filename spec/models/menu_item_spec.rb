require 'spec_helper'

describe MenuItem do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:menu_item, :otm_keywords => [Factory(:otm_keyword)])
  end

  it "should create a new instance given valid attributes" do
    MenuItem.create!(@valid_attributes)
  end
end

