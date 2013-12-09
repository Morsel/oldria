require_relative '../spec_helper'

describe NonculinaryEnrollment do
  it { should belong_to :profile }
  it { should belong_to :nonculinary_school }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:nonculinary_enrollment)
    @blank_school_attributes = {:name => '', :city => '', :state => '', :country => ''}
  end

  let (:profile) { FactoryGirl.create(:profile) }

  it "should create a new instance given valid attributes" do
    FactoryGirl.create(:nonculinary_enrollment)
  end

  it "should allow schools to be passed in directly" do
    school_attrs = FactoryGirl.attributes_for(:nonculinary_school, :name => "Custom School")
    attrs = @valid_attributes.merge(:nonculinary_school_attributes => school_attrs)
    enrollment = profile.nonculinary_enrollments.build(attrs)
    enrollment.save
    enrollment.nonculinary_school.name.should == "Custom School"
  end

  it "should ignore blank school attributes, favoring the school_id" do
    school = FactoryGirl.create(:nonculinary_school)
    attrs = @valid_attributes.merge(:nonculinary_school_id => school.id,
                                    :nonculinary_school_attributes => @blank_school_attributes)
    enrollment = profile.nonculinary_enrollments.create(attrs)
    enrollment.nonculinary_school.should == school
  end

  it "should ignore blank school attributes and strip out country field" do
    school = FactoryGirl.create(:nonculinary_school)
    attrs = @valid_attributes.merge(:nonculinary_school_id => school.id,
                                    :nonculinary_school_attributes => @blank_school_attributes.merge(:country => 'United States'))
    enrollment = profile.nonculinary_enrollments.create(attrs)
    enrollment.nonculinary_school.should == school
  end

  it "should not be valid when the school is absent" do
    enrollment = profile.enrollments.build(@valid_attributes)
    enrollment.should_not be_valid
  end

end

