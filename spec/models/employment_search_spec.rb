require 'spec_helper'

describe EmploymentSearch do
  before(:each) do
    @valid_attributes = {
      :conditions => "value for conditions"
    }
  end

  it "should create a new instance given valid attributes" do
    EmploymentSearch.create!(@valid_attributes)
  end
end
