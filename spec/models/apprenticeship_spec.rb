require 'spec_helper'

describe Apprenticeship do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:apprenticeship, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Apprenticeship.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: apprenticeships
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  supervisor    :string(255)
#  year          :integer
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

