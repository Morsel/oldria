require_relative '../spec_helper'

describe Profile do
  should_belong_to :user
  should_have_many :culinary_jobs
  should_have_many :nonculinary_jobs
  should_have_many :awards
  should_have_many :accolades
  should_have_many :enrollments
  should_have_many :nonculinary_enrollments
  should_have_many :schools, :through => :enrollments
  should_have_many :nonculinary_schools, :through => :nonculinary_enrollments

  it "exists for a user" do
    Factory(:profile).user.should be_present
  end
  
  it "recognizes public preferences" do
    profile = Factory(:profile)
    profile.preferred_display_cell = "everyone"
    profile.should be_display_cell_public
    profile.preferred_display_cell = "spoonfeed"
    profile.should_not be_display_cell_public
  end
end


