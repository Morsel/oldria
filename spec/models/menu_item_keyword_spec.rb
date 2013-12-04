require_relative '../spec_helper'

describe MenuItemKeyword do
  before(:each) do
    @valid_attributes = {
      :menu_item_id => 1,
      :otm_keyword_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    MenuItemKeyword.create!(@valid_attributes)
  end
end

