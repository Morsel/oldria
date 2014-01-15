require_relative '../spec_helper'

describe Specialty do
  it { should have_many(:profile_specialties) }
  it { should have_many(:trace_keywords) }
  it { should have_many(:profiles).through(:profile_specialties) }
  
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Specialty.create!(@valid_attributes)
  end
end

