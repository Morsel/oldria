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
  it { should have_many :competitions }
  it { should have_many :internships }
  it { should have_many :stages }
  it { should have_many :apprenticeships }
  it { should have_many :profile_cuisines }
  it { should have_many(:cuisines).through(:profile_cuisines) }
  it { should have_many :profile_specialties }
  it { should have_many(:specialties).through(:profile_specialties) }
  it { should belong_to(:metropolitan_area) }
  it { should belong_to(:james_beard_region) }
  it { should validate_uniqueness_of(:user_id) }
  it { should validate_presence_of(:hometown) }
  it { should validate_presence_of(:current_residence) }
  it { should ensure_length_of(:summary).is_at_most(1000) }
  it { should accept_nested_attributes_for(:culinary_jobs) }
  it { should accept_nested_attributes_for(:nonculinary_jobs) }
  it { should accept_nested_attributes_for(:awards) }
  it { should accept_nested_attributes_for(:user) }  
  it { should accept_nested_attributes_for(:specialties) }  

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

  describe "#primary_employment" do
    it "should return the primary employment" do
      profile = FactoryGirl.create(:profile)
      profile.primary_employment.should ==  profile.user.primary_employment
    end
  end

  describe "#non_culinary_work_experience_updated_at" do
    it "should return the non culinary work experience_updated_at" do
      profile = FactoryGirl.create(:profile)
      profile.non_culinary_work_experience_updated_at.should ==  profile.nonculinary_jobs.all(:order => :updated_at).last.try(:updated_at)
    end
  end

  describe "#birthday_year_is_set" do
    it "should return the birthday year is set" do
      profile = FactoryGirl.create(:profile)
      profile.birthday_year_is_set.should == profile.errors.add(:birthday, "must specify a year") if profile.birthday.present? && profile.birthday.year == 1
    end
  end

  describe "#culinary_schools" do
    it "should return the culinary_schools" do
      profile = FactoryGirl.create(:profile)
      profile.culinary_schools.should == profile.culinary_schools
    end
  end


end


