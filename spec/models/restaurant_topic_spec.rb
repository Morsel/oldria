require_relative '../spec_helper'

describe RestaurantTopic do
  it { should have_many(:restaurant_questions).through(:chapters) }

  before(:each) do
    @valid_attributes = {
      :title => "My Title",
      :description => "A description"
    }
  end

  it "should create a new instance given valid attributes" do
    RestaurantTopic.create!(@valid_attributes)
  end

  describe "#question_count_for_restaurant" do
    it "should return question_count_for_restaurant" do
      restaurant_topic = FactoryGirl.create(:restaurant_topic)
      restaurant = FactoryGirl.create(:restaurant)
      page = nil
      page.present? ? restaurant_topic.restaurant_questions.for_page(page).count : restaurant_topic.restaurant_questions.count
    end
  end

  describe "#answer_count_for_restaurant" do
    it "should return answer_count_for_restaurant" do
      restaurant_topic = FactoryGirl.create(:restaurant_topic)
      restaurant = FactoryGirl.create(:restaurant)
      page = nil
      page.present? ? restaurant_topic.restaurant_questions.for_page(page).count : restaurant_topic.restaurant_questions.count
    end
  end

  describe "#completion_percentage" do
    it "should return completion_percentage" do
      restaurant_topic = FactoryGirl.create(:restaurant_topic)
      restaurant = FactoryGirl.create(:restaurant)
      if restaurant_topic.question_count_for_restaurant(restaurant, page = nil) > 0
      	result = ((restaurant_topic.answer_count_for_restaurant(restaurant, page).to_f / restaurant_topic.question_count_for_restaurant(restaurant, page).to_f) * 100).to_i
      else
      	result = 0
      end 	
      restaurant_topic.completion_percentage(restaurant, page = nil).should == result
    end
  end

  describe "#published?" do
    it "should return published?" do
      restaurant_topic = FactoryGirl.create(:restaurant_topic)
      restaurant = FactoryGirl.create(:restaurant)
      restaurant_topic.published?(restaurant, page = nil).should == restaurant_topic.completion_percentage(restaurant, page) > 0
    end
  end


end

