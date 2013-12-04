require_relative '../spec_helper'

describe SiteActivity do
  before(:each) do
    @valid_attributes = {
      :description => "value for description"
    }
  end

  it "should create a new instance given valid attributes" do
    SiteActivity.create!(@valid_attributes)
  end
end

