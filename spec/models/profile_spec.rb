# == Schema Information
# Schema version: 20100805194513
#
# Table name: profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  birthday   :date
#  job_start  :date
#  cellnumber :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Profile do
  should_belong_to :user
  should_have_many :culinary_jobs
  should_have_many :nonculinary_jobs
  should_have_many :awards
  should_have_many :accolades

  it "exists for a user" do
    Factory(:profile).user.should be_present
  end
end
