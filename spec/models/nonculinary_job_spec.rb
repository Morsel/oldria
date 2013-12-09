require_relative '../spec_helper'

describe NonculinaryJob do
  it { should belong_to :profile }

  it "should create a new instance given valid attributes" do
    FactoryGirl.create(:nonculinary_job)
  end
end

