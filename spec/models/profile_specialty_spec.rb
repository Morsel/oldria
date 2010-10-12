require 'spec_helper'

describe ProfileSpecialty do
  before(:each) do
    @valid_attributes = {
      :profile_id => 1,
      :specialty_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ProfileSpecialty.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: profile_specialties
#
#  id           :integer         not null, primary key
#  profile_id   :integer
#  specialty_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#

