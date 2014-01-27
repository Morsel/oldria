require_relative '../../spec_helper'
	describe Soapbox::RestaurantQuestionsController do
	  it "index action should render show template" do
	  	@restaurant_question = FactoryGirl.create(:restaurant_question)
	    get :show,:id=>@restaurant_question.id
	    response.should render_template('restaurant_questions/show')
	  end
	end
