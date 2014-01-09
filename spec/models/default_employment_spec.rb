require_relative '../spec_helper'

describe DefaultEmployment do
  it { should have_many(:solo_discussions).with_foreign_key('employment_id').dependent(:destroy) }
  it { should have_many(:solo_media_discussions).with_foreign_key('employment_id').dependent(:destroy) }

  before(:each) do
    @valid_attributes = {
      :employee_id => 1,
      :restaurant_role_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    DefaultEmployment.create!(@valid_attributes)
  end

  describe "#restaurant" do
  	it "should return the nil" do
	    default_employment = FactoryGirl.create(:default_employment)
	    default_employment.restaurant.should == nil
	  end   
  end


  describe "#viewable_media_request_discussions" do
  	it "should return the approved media request" do
	    default_employment = FactoryGirl.create(:default_employment)
	    default_employment.viewable_media_request_discussions.should == default_employment.solo_media_discussions.approved
	  end   
  end

  describe "#viewable_unread_media_request_discussions" do
  	it "should return the unread media request" do
	    default_employment = FactoryGirl.create(:default_employment)
	    default_employment.viewable_unread_media_request_discussions.should == default_employment.solo_media_discussions.approved.select { |d| !d.read_by?(default_employment.employee) }
	  end   
  end


end

