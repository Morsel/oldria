# == Schema Information
#
# Table name: media_request_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  shortname  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  fields     :string(255)
#

require 'spec/spec_helper'

describe MediaRequestType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    MediaRequestType.create!(@valid_attributes)
  end
  
  describe "fieldset" do
    it "should return [] when there are no fields" do
      mrt = MediaRequestType.new(:name => "Family")
      mrt.fieldset.should == []
    end

    it "should split fields" do
      mrt = MediaRequestType.new(:name => "Family", :fields => "Date, Favorite Place")
      mrt.fieldset.should == ["date", "favorite_place"]
    end
  end
end
