require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe JamesBeardRegion do
  should_have_many :restaurants
  should_have_many :users

  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    JamesBeardRegion.create!(@valid_attributes)
  end
end
