require 'spec_helper'

describe EmploymentSearch do
  before(:each) do
    @r1 = Factory(:restaurant, :name => "Megan's Place")
    @e1 = Factory(:employment, :restaurant => @r1)
    @r2 = Factory(:restaurant, :name => "Joe's Diner")
    @e2 = Factory(:employment, :restaurant => @r2)
  end

  it "should search employments" do
    search = Employment.search({:restaurant_name_like => "megan"})
    employment_search = EmploymentSearch.new(:conditions => search.conditions)
    employment_search.save
    employment_search.reload
    employment_search.employments.count.should == 1
  end
end
