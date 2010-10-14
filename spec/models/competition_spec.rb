require 'spec_helper'

describe Competition do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:competition, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Competition.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: competitions
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  name       :string(255)
#  place      :string(255)
#  year       :integer
#  created_at :datetime
#  updated_at :datetime
#

