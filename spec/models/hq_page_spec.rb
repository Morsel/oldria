require_relative '../spec_helper'

describe HqPage do

 it { should_not allow_value('/^[\w\d_\-]+$/').for(:slug).on(:create).with_message("can only contain lowercase letters, numbers, underscores (_) and dashes (-)") }
 it { should validate_presence_of(:slug) }
 it { should callback(:generate_slug!).before(:validation) }
 it { should callback(:deletable?).before(:destroy) }
 
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:hq_page)
  end

  it "should create a new instance given valid attributes" do
    HqPage.create!(@valid_attributes)
  end

  it "is invalid without a title" do
	 	FactoryGirl.build(:hq_page, title: nil).should_not be_valid 
	end 


end 