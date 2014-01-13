require_relative '../spec_helper'

describe ProfileCuisine do
  it { should belong_to(:cuisine) }
  it { should belong_to(:profile) }
  it { should validate_presence_of(:profile_id) }  
  it { should validate_presence_of(:cuisine_id) }  
  it { should validate_uniqueness_of(:cuisine_id).scoped_to(:profile_id).
      with_message('This cuisine is already on your profile') }  

  before(:each) do
    @valid_attributes = {
      :profile_id => 1,
      :cuisine_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ProfileCuisine.create!(@valid_attributes)
  end
end

