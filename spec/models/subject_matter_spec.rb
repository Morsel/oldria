require_relative '../spec_helper'

describe SubjectMatter do
  should_have_many :responsibilities
  should_have_many :employments, :through => :responsibilities
  should_have_many :media_requests
  should_validate_presence_of :name
  should_have_default_scope :order => "subject_matters.name ASC"

  context "#admin_only?" do
    it "should be false by default" do
      SubjectMatter.new(:name => "Beer").should_not be_admin_only
    end

    it "should be true for RIA" do
      SubjectMatter.new(:name => "Beer (RIA)").should be_admin_only
    end
  end

  context "general information" do

    it "should not be a general subject matter by default" do
      SubjectMatter.create(:name => "not general").should_not be_general
    end

    it "should know about its descendants" do
      SubjectMatter.create(:name => "Food", :general => true).should be_general
    end

    context "class methods" do
      before(:all) do
        @general = SubjectMatter.create(:name => "Food", :general => true)
        @notgeneral1 = SubjectMatter.create(:name => "Photo Shoot")
        @notgeneral2 = SubjectMatter.create(:name => "Photo Shoot", :general => false)
      end
      after(:all) { SubjectMatter.destroy_all }

      it { SubjectMatter.should include(@general) }
      it { SubjectMatter.should_not include(@notgeneral1) }
      it { SubjectMatter.nongeneral.should include(@notgeneral1) }
      it { SubjectMatter.nongeneral.should include(@notgeneral2) }
      it { SubjectMatter.nongeneral.should_not include(@general) }
    end
  end

  describe "fieldset" do
    it "should return [] when there are no fields" do
      sm = SubjectMatter.new(:name => "Family")
      sm.fieldset.should == []
    end

    it "should split fields" do
      sm = SubjectMatter.new(:name => "Family", :fields => "Date, Favorite Place")
      sm.fieldset.should == ["date", "favorite_place"]
    end
  end
end
