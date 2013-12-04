require_relative '../spec_helper'

describe MediaRequestDiscussion do
  should_belong_to :media_request
  should_belong_to :restaurant


  it "should know its employments" do
    restaurant = Factory(:restaurant)

    search = EmploymentSearch.new(:conditions => {:restaurant_id_eq => restaurant.id.to_s})
    media_request = Factory(:media_request, :employment_search => search)

    discussion = media_request.discussion_with_restaurant(restaurant)
    discussion.employments.should == restaurant.employments
  end

end
