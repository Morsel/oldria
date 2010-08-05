require 'spec_helper'

describe Profile do
  should_belong_to :user

  it "exists for a user" do
    Factory(:profile).user.should be_present
  end
end
