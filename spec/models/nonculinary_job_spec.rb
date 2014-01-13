require_relative '../spec_helper'

describe NonculinaryJob do
  it { should belong_to :profile }
  it { should validate_presence_of(:company) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:date_started) }
  it { should validate_presence_of(:responsibilities) }

  it "should create a new instance given valid attributes" do
    FactoryGirl.create(:nonculinary_job)
  end

  it "should always have a date started before date ended" do
    nonculinary_job = FactoryGirl.build(:nonculinary_job)
    nonculinary_job.company = "company"
    nonculinary_job.title = "title"
    nonculinary_job.city = "city"
    nonculinary_job.state = "state"
    nonculinary_job.country = "country"
    nonculinary_job.date_started = 1.year.ago
    nonculinary_job.date_ended = 2.years.ago
    nonculinary_job.should_not be_valid
    nonculinary_job.date_ended = Date.today
    nonculinary_job.should be_valid
  end

end

