require 'spec_helper'

describe QuestionRole do
  before(:each) do
    @valid_attributes = {
      :profile_question_id => 1,
      :restaurant_role_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    QuestionRole.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: question_roles
#
#  id                  :integer         not null, primary key
#  profile_question_id :integer
#  restaurant_role_id  :integer
#  created_at          :datetime
#  updated_at          :datetime
#

