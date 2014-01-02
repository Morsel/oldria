require_relative '../spec_helper'

describe FeaturedProfile do
	it { should belong_to :feature }
	it { should validate_presence_of(:feature_id) }
	it { should validate_presence_of(:start_date) }
	it do
    should validate_uniqueness_of(:feature_id).scoped_to(:feature_type)
  end

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:featured_profile)
  end

  it "should create a new instance given valid attributes" do
    FeaturedProfile.create!(@valid_attributes)
  end

end 