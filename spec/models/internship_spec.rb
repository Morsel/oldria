require 'spec_helper'

describe Internship do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:internship, :profile => Factory(:profile))
  end

  it "should create a new instance given valid attributes" do
    Internship.create!(@valid_attributes)
  end
end

# == Schema Information
#
# Table name: internships
#
#  id            :integer         not null, primary key
#  establishment :string(255)
#  supervisor    :string(255)
#  start_date    :date
#  end_date      :date
#  comments      :text
#  profile_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

