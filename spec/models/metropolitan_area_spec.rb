require_relative '../spec_helper'

describe MetropolitanArea do
  it { should have_many(:restaurants) }
  it { should have_many(:profiles) }
  #it { should have_many(:trace_searches) }
  it { should have_and_belong_to_many(:users) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:state) }


  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    MetropolitanArea.create!(@valid_attributes)
  end

  describe "#to_label" do
    it "should return to label" do
      metropolitan_area = MetropolitanArea.create!(@valid_attributes)
      metropolitan_area.to_label.should == "#{metropolitan_area.state}: #{metropolitan_area.name}"
    end   
  end

  describe "#city_and_state" do
    it "should return to city and state" do
      metropolitan_area = MetropolitanArea.create!(@valid_attributes)
      metropolitan_area.city_and_state.should ==  "#{metropolitan_area.name}, #{metropolitan_area.state}"
    end   
  end

end

