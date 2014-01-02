require_relative '../spec_helper'

describe RegionalWriter do
	it { should belong_to :regional_writer }
	it { should belong_to :user }
  it { should belong_to :james_beard_region }


  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:regional_writer)
  end

  it "should create a new instance given valid attributes" do
    RegionalWriter.create!(@valid_attributes)
  end

  it "is invalid without a james_beard_region_id" do
	 	FactoryGirl.build(:regional_writer, james_beard_region_id: nil).should_not be_valid 
	end 




end 