require 'spec_helper'

describe Accolade do
  should_validate_presence_of :name, :run_date

  before(:each) do
    @valid_attributes = Factory.attributes_for(:accolade)
  end

  it "should create a new instance given valid attributes" do
    Accolade.create!(@valid_attributes)
  end

  it "should only allow valid media types" do
    accolade = Factory.build(:accolade)
    accolade.media_type = "Foobad"
    accolade.should_not be_valid
    accolade.media_type = Accolade.valid_media_types.first
    accolade.should be_valid
  end

  it "should recognize its type" do
    accolade = Factory.build(:accolade)
    accolade.should_not be_restaurant
    accolade.accoladable = Factory.build(:restaurant)
    accolade.should be_restaurant
  end

  it "sorts by run date" do
    accolade1 = Factory.create(:accolade, :run_date => 1.year.ago)
    accolade2 = Factory.create(:accolade, :run_date => 1.day.ago)
    Accolade.by_run_date.all.should == [accolade2, accolade1]
  end

end

