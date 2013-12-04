require_relative '../spec_helper'

describe TrendQuestionsController do

  before(:each) do
    user = Factory(:user)
    controller.stubs(:current_user).returns(:user)
  end

  it "should show a question with responses" do
    question = Factory(:trend_question)
    get :show, :id => question.id
    assigns[:trend_question].should_not be_nil
    assigns[:discussions].should_not be_nil
  end

  it "should show responses for a restaurant" do
    question = Factory(:trend_question)
    restaurant = Factory(:restaurant)
    Factory(:admin_discussion, :discussionable => question, :restaurant => restaurant)
    get :restaurant, :restaurant_id => restaurant.id
    assigns[:discussions].should_not be_nil
  end

end
