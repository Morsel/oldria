require_relative '../spec_helper'

describe Profile do
  it { should belong_to :user }
  it { should have_many :culinary_jobs }
  it { should have_many :nonculinary_jobs }
  it { should have_many :awards }
  it { should have_many :accolades }
  it { should have_many :enrollments }
  it { should have_many :nonculinary_enrollments }
  it { should have_many(:schools).through(:enrollments) }
  it { should have_many(:nonculinary_schools).through(:nonculinary_enrollments) }

  it "exists for a user" do
    FactoryGirl.create(:profile).user.should be_present
  end
  
  it "recognizes public preferences" do
    profile = FactoryGirl.create(:profile)
    profile.preferred_display_cell = "everyone"
    profile.should be_display_cell_public
    profile.preferred_display_cell = "spoonfeed"
    profile.should_not be_display_cell_public
  end
end


