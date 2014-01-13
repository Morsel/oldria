require_relative '../spec_helper'

describe OtmKeyword do
  it { should have_many(:menu_item_keywords).dependent(:destroy) }
  it { should have_many(:menu_items).through(:menu_item_keywords) }

  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :category => "value for category"
    }
  end

  it "should create a new instance given valid attributes" do
    OtmKeyword.create!(@valid_attributes)
  end

  describe "#name_with_category" do
  	it "should return the name with category" do
	  	otm_keyword = OtmKeyword.create!(@valid_attributes)
	  	otm_keyword.name_with_category.should == "#{otm_keyword.category}: #{otm_keyword.name}"
    end
  end

end

