require_relative '../../spec_helper'

describe Restaurants::BehindTheLineController do
integrate_views
  before(:each) do
    fake_admin_user
  end

  it "index action should render index template" do
  	@restaurant = FactoryGirl.create(:restaurant)
    get :index, restaurant_id: @restaurant.id
    response.should render_template(:index)
  end

  it "it should render question_ans_post template" do
  	@question = FactoryGirl.create(:restaurant_question)
  	@restaurant = FactoryGirl.create(:restaurant)
    get :question_ans_post, restaurant_id: @restaurant.id, id: @question.id
    response.should render_template(:question_ans_post)
  end




end
