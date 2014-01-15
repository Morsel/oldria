require_relative '../spec_helper'

describe Stage do
  it { should belong_to(:profile) }
  it { should validate_presence_of(:establishment) }
  it { should validate_presence_of(:expert) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:profile_id) }
        	
  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:stage)
    @valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Stage.create!(@valid_attributes)
  end

  it "should always have a date started before date ended" do
    stage = FactoryGirl.build(:stage)
    stage.establishment = "Po"
    stage.expert = "Mario Batali"
    stage.start_date = "1997-04-26"
    stage.profile_id = "35"
    stage.start_date = 1.year.ago
    stage.end_date = 2.years.ago
    stage.should_not be_valid
    stage.end_date = Date.today
    stage.should be_valid
  end


end


