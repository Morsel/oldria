require_relative '../spec_helper'

describe TrendQuestionsController do

  before(:each) do
    user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns(:user)
  end

  it "should show a question with responses" do
    question = FactoryGirl.create(:trend_question)
    get :show, :id => question.id
    assigns[:trend_question].should_not be_nil
    assigns[:discussions].should_not be_nil
  end

  it "should show responses for a restaurant" do
    question = FactoryGirl.create(:trend_question)
    restaurant = FactoryGirl.create(:restaurant)
    FactoryGirl.create(:admin_discussion, :discussionable => question, :restaurant => restaurant)
    get :restaurant, :restaurant_id => restaurant.id
    assigns[:discussions].should_not be_nil
  end

end
