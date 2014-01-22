require_relative '../spec_helper'

describe InviteResponsibility do
  it { should belong_to(:invitation) }
  it { should belong_to(:subject_matter) }
  before(:each) do
    @valid_attributes = {
      :invitation_id => 1,
      :subject_matter_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    InviteResponsibility.create!(@valid_attributes)
  end
end

