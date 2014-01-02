require_relative '../spec_helper'

describe MetropolitanAreasWriter do
  it { should belong_to :area_writer }
	it { should belong_to :user }
  it { should belong_to :metropolitan_area }
  it { should validate_presence_of(:metropolitan_area_id) }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:metropolitan_areas_writer)
  end

  it "should create a new instance given valid attributes" do
    MetropolitanAreasWriter.create!(@valid_attributes)
  end

end	

