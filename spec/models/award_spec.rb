require 'spec_helper'

describe Award do
  should_belong_to :profile

  before(:each) do
    @valid_attributes = Factory.attributes_for(:award)
  end

  it "should create a new instance given valid attributes" do
    Award.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: awards
#
#  id             :integer         not null, primary key
#  profile_id     :integer
#  name           :string(255)
#  year_won       :string(4)       default(""), not null
#  year_nominated :string(4)       default(""), not null
#  created_at     :datetime
#  updated_at     :datetime
#

