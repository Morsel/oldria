require 'spec_helper'

describe Stage do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:stage, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Stage.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: stages
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  expert        :string(255)
#  start_date    :date
#  end_date      :date
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

