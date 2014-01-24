require_relative '../../spec_helper'

describe Soapbox::ALaMinuteQuestionsController do
  integrate_views

  describe "GET index" do
    it "assigns all answers as @answers" do
    	get :index
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "Get question , answers and sidebar_questions" do
      @a_la_minute_question = FactoryGirl.create(:a_la_minute_question)
      get :show ,:id=>@a_la_minute_question.id
      response.should render_template(:show)
    end
  end

end 