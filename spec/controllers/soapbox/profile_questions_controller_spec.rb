require_relative '../../spec_helper'
describe Soapbox::ProfileQuestionsController do

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "index action should render show template" do
  	@profile_question = FactoryGirl.create(:profile_question)
    get :show,:id=>@profile_question.id
    response.should render_template(:show)
  end

end 