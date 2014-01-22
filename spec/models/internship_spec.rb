require_relative '../spec_helper'

describe Internship do
	it { should validate_presence_of(:establishment) }
	it { should validate_presence_of(:supervisor) }
	it { should validate_presence_of(:start_date) }
	it { should validate_presence_of(:profile_id) }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:internship)
    @valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Internship.create!(@valid_attributes)
  end

  it "should always have a date started before date ended" do
    internship = FactoryGirl.create(:internship)
    profile = FactoryGirl.create(:profile)
    internship.establishment = "Po"
    internship.supervisor = "Mario Batali"
    internship.start_date = "1997-04-26"
    internship.profile_id = profile.id
    internship.end_date = Date.today
    internship.should be_valid
  end


end

