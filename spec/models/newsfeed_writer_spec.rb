require_relative '../spec_helper'

describe NewsfeedWriter do
	it { should have_many :users }
  it { should have_many :metropolitan_areas_writers }
  it { should have_many :regional_writers }
  it { should accept_nested_attributes_for :metropolitan_areas_writers }
  it { should accept_nested_attributes_for :regional_writers }

  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:newsfeed_writer)
  end

  it "should create a new instance given valid attributes" do
    NewsfeedWriter.create!(@valid_attributes)
  end

  describe "#find_metropolitan_areas_writers" do
    newsfeed_writer = FactoryGirl.create(:newsfeed_writer)
    user = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
    user.save(:validate => false)
    newsfeed_writer.find_metropolitan_areas_writers(user).should ==  newsfeed_writer.metropolitan_areas_writers.find(:all,:conditions=>["user_id=?",user])
  end
 
  describe "#find_regional_writers" do
    newsfeed_writer = FactoryGirl.create(:newsfeed_writer)
    user = FactoryGirl.build(:user, :username => 'sender',:email=>"rewr.23@gmail.com")
    user.save(:validate => false)
    newsfeed_writer.find_regional_writers(user).should ==  newsfeed_writer.regional_writers.find(:all,:conditions=>["user_id=?",user])
  end
 

end	

