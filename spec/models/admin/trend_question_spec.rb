# == Schema Information
# Schema version: 20100303185000
#
# Table name: admin_messages
#
#  id           :integer         not null, primary key
#  type         :string(255)
#  scheduled_at :datetime
#  status       :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  holiday_id   :integer
#

require 'spec/spec_helper'

describe Admin::TrendQuestion do
  it "should inherit from Admin::Message" do
    Admin::TrendQuestion.new.should be_an(Admin::Message)
  end

  it "should set a class-based title of 'Seasonal/Trend Question'" do
    Admin::TrendQuestion.title.should == "Seasonal/Trend Question"
  end
end
