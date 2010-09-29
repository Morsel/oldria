require 'spec_helper'

describe Accolade do
  should_belong_to :profile
  should_validate_presence_of :name, :run_date

  before(:each) do
    @valid_attributes = Factory.attributes_for(:accolade)
  end

  it "should create a new instance given valid attributes" do
    Accolade.create!(@valid_attributes)
  end

  it "should only allow valid media types" do
    accolade = Factory.build(:accolade)
    accolade.media_type = "Foobad"
    accolade.should_not be_valid
    accolade.media_type = Accolade.valid_media_types.first
    accolade.should be_valid
  end
end

# == Schema Information
#
# Table name: accolades
#
#  id         :integer         not null, primary key
#  profile_id :integer
#  name       :string(255)     default(""), not null
#  media_type :string(255)     default(""), not null
#  run_date   :date            not null
#  created_at :datetime
#  updated_at :datetime
#  link       :string(255)
#

