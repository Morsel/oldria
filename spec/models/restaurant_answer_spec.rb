require_relative '../spec_helper'

describe RestaurantAnswer do
  it { should belong_to(:restaurant_question) }
  it { should belong_to(:restaurant) }
  it { should validate_presence_of(:answer) }
  it { should validate_presence_of(:restaurant_question_id) }
  it { should validate_presence_of(:restaurant_id) }
  it { should validate_uniqueness_of(:restaurant_question_id).scoped_to(:restaurant_id) }
  it { should have_many(:twitter_posts).dependent(:destroy) }
  it { should have_many(:facebook_posts).dependent(:destroy) }    
  it { should accept_nested_attributes_for(:twitter_posts).limit(1).allow_destroy(true) }  
  it { should accept_nested_attributes_for(:facebook_posts).limit(1).allow_destroy(true) }  

  before(:each) do
    @valid_attributes = {
      :restaurant_question_id => 1,
      :answer => "value for answer",
      :restaurant_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantAnswer.create!(@valid_attributes)
  end

  describe ".recently_answered" do
    it "should return the recently_answered" do
      restaurant_answer = FactoryGirl.build(:restaurant_answer)
      RestaurantAnswer.recently_answered.should == RestaurantAnswer.find(:all, :order => "created_at DESC")
    end
  end 

  describe "#activity_name" do
    it "should return the activity_name" do
      restaurant_answer = FactoryGirl.build(:restaurant_answer)
      restaurant_answer.activity_name.should == "Restaurant Question Answer"
    end
  end 


end 
