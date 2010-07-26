# == Schema Information
# Schema version: 20100708221553
#
# Table name: media_request_discussions
#
#  id               :integer         not null, primary key
#  media_request_id :integer
#  restaurant_id    :integer
#  comments_count   :integer         default(0)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec/spec_helper'

describe MediaRequestDiscussion do
  should_belong_to :media_request
  should_belong_to :restaurant


  it "should know its employments" do
    restaurant = Factory(:restaurant)
    employment = Factory(:employment, :restaurant => restaurant, :omniscient => true)

    search = EmploymentSearch.new(:conditions => {:restaurant_id_eq => restaurant.id.to_s})
    media_request = Factory(:media_request, :employment_search => search)

    discussion = media_request.discussion_with_restaurant(restaurant)
    discussion.employments.should == [employment]
  end

end
