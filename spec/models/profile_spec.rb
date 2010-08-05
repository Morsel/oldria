require 'spec_helper'

describe Profile do
  should_belong_to :user
  should_have_many :extended_profile_items

  it "exists for a user" do
    Factory(:profile).user.should be_present
  end
end
