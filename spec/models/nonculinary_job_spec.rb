require_relative '../spec_helper'

describe NonculinaryJob do
  should_belong_to :profile

  it "should create a new instance given valid attributes" do
    Factory(:nonculinary_job)
  end
end

