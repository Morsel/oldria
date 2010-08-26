# == Schema Information
# Schema version: 20100817161538
#
# Table name: culinary_jobs
#
#  id           :integer(4)      not null, primary key
#  profile_id   :integer(4)      not null
#  title        :string(255)     default(""), not null
#  city         :string(255)     default(""), not null
#  state        :string(255)     default(""), not null
#  date_started :date            not null
#  date_ended   :date
#  chef_name    :string(255)     default(""), not null
#  chef_is_me   :boolean(1)      not null
#  cuisine      :text            default(""), not null
#  notes        :text            default(""), not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe CulinaryJob do
  should_belong_to :profile

  it "should always have a date started before date ended" do
    culinary_job = Factory.build(:culinary_job)
    culinary_job.country = "United States"
    culinary_job.date_started = 1.year.ago
    culinary_job.date_ended = 2.years.ago
    culinary_job.should_not be_valid
    culinary_job.date_ended = Date.today
    culinary_job.should be_valid
  end
end
