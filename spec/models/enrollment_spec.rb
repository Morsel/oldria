require_relative '../spec_helper'

describe Enrollment do
  it { should belong_to :profile }
  it { should belong_to :school }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:enrollment)
    @blank_school_attributes = {:name => '', :city => '', :state => '', :country => ''}
  end

  let (:profile) { FactoryGirl.create(:profile) }

  it "should create a new instance given valid attributes" do
    FactoryGirl.create(:enrollment)
  end

  it "should allow schools to be passed in directly" do
    school_attrs = FactoryGirl.attributes_for(:school, :name => "Custom School")
    attrs = @valid_attributes.merge(:school_attributes => school_attrs)
    enrollment = profile.enrollments.build(attrs)
    enrollment.save
    enrollment.school.name.should == "Custom School"
  end

  it "should ignore blank school attributes, favoring the school_id" do
    school = FactoryGirl.create(:school)
    attrs = @valid_attributes.merge(:school_id => school.id,
                                    :school_attributes => @blank_school_attributes)
    enrollment = profile.enrollments.create(attrs)
    enrollment.school.should == school
  end

  it "should ignore blank school attributes and strip out country field" do
    school = FactoryGirl.create(:school)
    attrs = @valid_attributes.merge(:school_id => school.id,
                                    :school_attributes => @blank_school_attributes.merge(:country => 'United States'))
    enrollment = profile.enrollments.create(attrs)
    enrollment.school.should == school
  end

  it "should not be valid when the school is absent" do
    enrollment = profile.enrollments.build(@valid_attributes)
    enrollment.should_not be_valid
  end

  xit "should ignore school attributes when the school already exists" do
    school = FactoryGirl.create(:school)
    school_attrs = FactoryGirl.attributes_for(:school, :name => "Custom School")
    attrs = @valid_attributes.merge(:school_id => school.id, :school_attributes => school_attrs)
    enrollment = profile.enrollments.build(attrs)
    enrollment.save
    enrollment.school.name.should_not == "Custom School"
  end
  
end

