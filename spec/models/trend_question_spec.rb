# == Schema Information
# Schema version: 20100409155415
#
# Table name: trend_questions
#
#  id           :integer         not null, primary key
#  subject      :string(255)
#  body         :text
#  scheduled_at :datetime
#  expired_at   :datetime
#  criteria_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe TrendQuestion do
  before(:each) do
    @valid_attributes = {
      :subject => "value for subject",
      :body => "value for body",
      :scheduled_at => Time.now,
      :expired_at => Time.now,
      :criteria_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    TrendQuestion.create!(@valid_attributes)
  end
end
