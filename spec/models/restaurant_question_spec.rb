require_relative '../spec_helper'

describe RestaurantQuestion do
  it { should belong_to(:chapter) }
  it { should have_many(:question_pages).dependent(:destroy) }
  it { should have_many(:restaurant_feature_pages).through(:question_pages) }
  it { should have_many(:restaurant_answers).dependent(:destroy) }  
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:chapter_id) }
  it { should validate_uniqueness_of(:title).scoped_to(:chapter_id).case_insensitive } 

  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :position => 1,
      :chapter_id => 1,
      :pages_description => "value for pages_description"
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantQuestion.create!(@valid_attributes)
  end

  describe "#topic" do
    it "should return topic" do
      restaurant_question = FactoryGirl.create(:restaurant_question)
      restaurant_question.topic.should == restaurant_question.chapter.topic
    end
  end

  describe "#answered_by?" do
    it "should return answered_by?" do
      restaurant_question = FactoryGirl.create(:restaurant_question)
      restaurant = FactoryGirl.create(:restaurant)
      restaurant_question.answered_by?(restaurant).should == restaurant_question.restaurant_answers.exists?(:restaurant_id => restaurant.id)
    end
  end

  describe "#answer_for" do
    it "should return answer_for" do
      restaurant_question = FactoryGirl.create(:restaurant_question)
      restaurant = FactoryGirl.create(:restaurant)
      restaurant_question.answer_for(restaurant).should == restaurant_question.restaurant_answers.select { |a| a.restaurant == restaurant }.first
    end
  end

  describe "#latest_soapbox_answer" do
    it "should return latest_soapbox_answer" do
      restaurant_question = FactoryGirl.create(:restaurant_question)
      restaurant_question.latest_soapbox_answer.should == restaurant_question.restaurant_answers.from_premium_restaurants.first(:order => "created_at DESC")
    end
  end  

  describe "#email_title" do
    it "should return email_title" do
      restaurant_question = FactoryGirl.create(:restaurant_question)
      restaurant_question.email_title.should == "Behind the Line"
    end
  end  

end

