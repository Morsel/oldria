require 'spec_helper'

describe ProfileAnswersController do
  
  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
    @profile = Factory(:profile, :user => current_user)
    Factory(:default_employment, :employee => current_user)
  end

  it "should create a new answer" do
    question = Factory(:profile_question)
    answer = Factory.build(:profile_answer)

    ProfileQuestion.expects(:find).with(question.id).returns(question)
    question.expects(:find_or_build_answer_for).returns(answer)
    answer.expects(:save).returns(true)

    post :create, :profile_question => { question.id => { :answer => "Something!" }}, :format => "html"
    response.should be_redirect
  end
  
  it "should let a user update an existing answer" do
    answer = Factory(:profile_answer)
    ProfileAnswer.expects(:find).returns(answer)
    answer.expects(:update_attributes).with("answer" => "Something else!").returns(true)
    put :update, :id => answer.id, :profile_answer => { :answer => "Something else!" }
    response.should be_redirect
  end
  
  it "should let a user delete their answer" do
    answer = Factory(:profile_answer)
    ProfileAnswer.expects(:find).returns(answer)
    answer.expects(:destroy).returns(true)
    delete :destroy, :id => answer.id
    response.should be_redirect
  end

end
