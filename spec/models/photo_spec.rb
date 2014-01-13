require_relative '../spec_helper'

describe Photo do

  it { should validate_presence_of(:credit) }
  it { should have_attached_file(:attachment) }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:photo)
  end

  it "should create a new instance given valid attributes" do
    Photo.create!(@valid_attributes)
  end

  describe "#activity_name" do
  	it "should return the activity name" do
	  	photo = FactoryGirl.build(:photo)
	  	photo.activity_name.should == "photo"
    end
  end


end 

