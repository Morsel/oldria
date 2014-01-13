require_relative '../spec_helper'

describe MenuItemKeyword do
  it { should belong_to(:menu_item) }
  it { should belong_to(:otm_keyword) }

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

