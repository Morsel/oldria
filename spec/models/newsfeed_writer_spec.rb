require_relative '../spec_helper'

describe NewsfeedWriter do
	it { should have_many :users }
  it { should have_many :metropolitan_areas_writers }
  it { should have_many :regional_writers }
  it { should accept_nested_attributes_for :metropolitan_areas_writers }
  it { should accept_nested_attributes_for :regional_writers }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:newsfeed_writer)
  end

  it "should create a new instance given valid attributes" do
    NewsfeedWriter.create!(@valid_attributes)
  end

end	

