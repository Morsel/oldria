require 'spec_helper'

describe EmploymentSearch do
  before(:each) do
    @valid_attributes = {
      :conditions => { :restaurant_name_like => "neo" }
    }
  end

  it "should create a new instance given valid attributes" do
    EmploymentSearch.create!(@valid_attributes)
  end
end
