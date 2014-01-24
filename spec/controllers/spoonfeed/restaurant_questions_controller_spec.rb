require_relative '../../spec_helper'

describe Spoonfeed::RestaurantQuestionsController do
integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "Will get all the restaurant questions" do
      get :index
      @answers = RestaurantQuestion.answered_by_premium_restaurants.all(:limit => 50, :order => "restaurant_answers.created_at DESC").map(&:latest_soapbox_answer).uniq.compact[0...15]
      assigns[:answers].should == @answers
      response.should render_template('index')
    end
  end

  describe "GET show" do
    it "Will get all the restaurant questions" do
    	@restaurant_question = FactoryGirl.create(:restaurant_question)
      get :show,:id=>@restaurant_question.id
      assigns[:answers].should == @restaurant_question.restaurant_answers.from_premium_restaurants.recently_answered
      response.should render_template('show')
    end
  end

end
