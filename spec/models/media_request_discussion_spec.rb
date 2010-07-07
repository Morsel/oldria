require 'spec/spec_helper'

describe MediaRequestDiscussion do
  should_belong_to :media_request
  should_belong_to :restaurant
  
  
  it "should know its employments" do
    restaurant = Factory(:restaurant)
    employee = Factory(:user, :name => "Zach Dan")
    employment1 = Factory(:employment, :restaurant => restaurant)
    employment2 = Factory(:employment, :employee => employee)
    employment3 = Factory(:employment, :restaurant => restaurant, :employee => employee)
    employment_search = EmploymentSearch.new(:conditions => {:employee_first_name_like => "Z"})
    media_request = Factory(:media_request, :employment_search => employment_search)
    
    media_request.media_request_discussions.count.should == 2
    
    discussion = media_request.discussion_with_restaurant(restaurant)
    
    discussion.employments.should == [employment3]
    
  end
  
end
