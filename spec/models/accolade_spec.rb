require_relative '../spec_helper'

describe Accolade do
  it { should validate_presence_of :name }
  it { should validate_presence_of :run_date }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:accolade)
  end

  it "should create a new instance given valid attributes" do
    Accolade.create!(@valid_attributes)
  end

  it "should only allow valid media types" do
    accolade = FactoryGirl.build(:accolade)
    accolade.media_type = "Foobad"
    accolade.should_not be_valid
    accolade.media_type = Accolade.valid_media_types.first
    accolade.should be_valid
  end

  it "should recognize its type" do
    accolade = FactoryGirl.build(:accolade)
    accolade.should_not be_restaurant
    accolade.accoladable = FactoryGirl.build(:restaurant)
    accolade.should be_restaurant
  end

  it "sorts by run date" do
    accolade1 = FactoryGirl.create(:accolade, :run_date => 1.year.ago)
    accolade2 = FactoryGirl.create(:accolade, :run_date => 1.day.ago)
    Accolade.by_run_date.all.should == [accolade2, accolade1]
  end

  describe "#restaurant?" do
    accolade = FactoryGirl.create(:accolade)
    accolade.restaurant?.should == accolade.accoladable.is_a?(Restaurant)
  end


end

