require_relative '../spec_helper'

describe CulinaryJob do
  it { should belong_to :profile }
  it { should validate_presence_of :restaurant_name }
  it { should validate_presence_of :title }
  it { should validate_presence_of :city }
  it { should validate_presence_of :state }
  it { should validate_presence_of :country }
  it { should validate_presence_of :date_started }
  it { should validate_presence_of :chef_name }
  it { should validate_presence_of :cuisine }


  it "should always have a date started before date ended" do
    culinary_job = FactoryGirl.build(:culinary_job)
    culinary_job.country = "United States"
    culinary_job.date_started = 1.year.ago
    culinary_job.date_ended = 2.years.ago
    culinary_job.should_not be_valid
    culinary_job.date_ended = Date.today
    culinary_job.should be_valid
  end
end


