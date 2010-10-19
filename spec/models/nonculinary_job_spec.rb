require 'spec_helper'

describe NonculinaryJob do
  should_belong_to :profile

  it "should create a new instance given valid attributes" do
    Factory(:nonculinary_job)
  end
end

# == Schema Information
#
# Table name: nonculinary_jobs
#
#  id                 :integer         not null, primary key
#  profile_id         :integer
#  company            :string(255)     default(""), not null
#  title              :string(255)     default(""), not null
#  city               :string(255)     default(""), not null
#  state              :string(255)     default(""), not null
#  country            :string(255)     default(""), not null
#  date_started       :date            not null
#  date_ended         :date
#  responsibilities   :text            default(""), not null
#  reason_for_leaving :text            default(""), not null
#  created_at         :datetime
#  updated_at         :datetime
#

