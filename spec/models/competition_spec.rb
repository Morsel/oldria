require_relative '../spec_helper'

describe Competition do

 it { should belong_to(:profile) }
 it { should validate_presence_of(:name) }
 it { should validate_presence_of(:place) }
 it { should validate_presence_of(:year) }
 it { should validate_presence_of(:profile_id) }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:competition)
  	@valid_attributes[:profile] = FactoryGirl.create(:profile)
  end

  it "should create a new instance given valid attributes" do
    Competition.create!(@valid_attributes)
  end
end

