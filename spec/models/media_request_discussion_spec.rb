require_relative '../spec_helper'

describe MediaRequestDiscussion do
  it { should belong_to :media_request }
  it { should belong_to :restaurant }


  it "should know its employments" do
    restaurant = FactoryGirl.create(:restaurant)

    search = EmploymentSearch.new(:conditions => {:restaurant_id_eq => restaurant.id.to_s})
    media_request = FactoryGirl.create(:media_request, :employment_search => search)

    discussion = media_request.discussion_with_restaurant(restaurant)
    discussion.employments.should == restaurant.employments
  end

end
