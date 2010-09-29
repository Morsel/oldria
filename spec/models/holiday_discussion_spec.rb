require 'spec_helper'

describe HolidayDiscussion do
  before(:each) do
    @valid_attributes = {
      :restaurant_id => 1,
      :holiday_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    HolidayDiscussion.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: holiday_discussions
#
#  id             :integer         not null, primary key
#  restaurant_id  :integer
#  holiday_id     :integer
#  comments_count :integer         default(0)
#  created_at     :datetime
#  updated_at     :datetime
#  accepted       :boolean         default(FALSE)
#

