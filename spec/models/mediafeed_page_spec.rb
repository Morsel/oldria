require_relative '../spec_helper'

describe MediafeedPage do

 it { should_not allow_value('/^[\w\d_\-]+$/').for(:slug).with_message("can only contain lowercase letters, numbers, underscores (_) and dashes (-)") }
 it { should validate_presence_of(:slug) }
 it { should callback(:generate_slug!).before(:validation) }
 it { should callback(:deletable?).before(:destroy) }
 
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:mediafeed_page)
  end

  it "should create a new instance given valid attributes" do
    MediafeedPage.create!(@valid_attributes)
  end

  it "is invalid without a title" do
	 	FactoryGirl.build(:mediafeed_page, title: nil).should_not be_valid 
	end 


end 