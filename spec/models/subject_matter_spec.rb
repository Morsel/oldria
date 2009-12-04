require 'spec/spec_helper'

describe SubjectMatter do
  should_have_many :responsibilities
  should_have_many :employments, :through => :responsibilities
  should_validate_presence_of :name
  should_have_default_scope :order => :name

  context "#admin_only?" do
    it "should be false by default" do
      SubjectMatter.new(:name => "Beer").should_not be_admin_only
    end

    it "should be true for RIA" do
      SubjectMatter.new(:name => "Beer (RIA)").should be_admin_only
    end
  end
end
