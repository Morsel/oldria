require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MediaRequestType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    MediaRequestType.create!(@valid_attributes)
  end
  
  describe "fieldset" do
    it "should return [] when there are no fields" do
      mrt = MediaRequestType.new(:name => "Family")
      mrt.fieldset.should == []
    end

    it "should split fields" do
      mrt = MediaRequestType.new(:name => "Family", :fields => "Date, Favorite Place")
      mrt.fieldset.should == ["date", "favorite_place"]
    end
  end
end
