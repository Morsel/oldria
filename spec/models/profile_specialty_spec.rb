require_relative '../spec_helper'

describe ProfileSpecialty do
  before(:each) do
    @valid_attributes = {
      :profile_id => 1,
      :specialty_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ProfileSpecialty.create!(@valid_attributes)
  end
end

