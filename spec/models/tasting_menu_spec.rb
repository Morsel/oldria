require_relative '../spec_helper'

describe TastingMenu do

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:tasting_menu)
  end

  it "should create a new instance given valid attributes" do
    TastingMenu.create!(@valid_attributes)
  end
end 