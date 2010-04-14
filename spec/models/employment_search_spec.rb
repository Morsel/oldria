# == Schema Information
# Schema version: 20100412193718
#
# Table name: employment_searches
#
#  id         :integer         not null, primary key
#  conditions :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec/spec_helper'

describe EmploymentSearch do
  should_have_one :content_request
  should_have_one :trend_question
  should_have_one :holiday

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
  
  describe "conditions" do
    before do
      @search = Employment.search({:restaurant_id_eq => @r1.id.to_s })
      @employment_search = EmploymentSearch.new(:conditions => @search.conditions)
    end

    describe "for readability" do
      it "should provide hash of conditions" do
        @employment_search.readable_conditions_hash.should be_a(Hash)
      end
      
      it "should allow an array of prettier conditions" do
        @employment_search.readable_conditions.should include("Restaurant: Megan's Place")
      end
      
      it "should work for restaurant role" do
        restaurant_role = Factory(:restaurant_role, :name => "Waiter")
        search = EmploymentSearch.new(:conditions => {:restaurant_role_id_eq => restaurant_role.id })
        search.readable_conditions.should include("Role: Waiter")
      end
    end
  end
end
