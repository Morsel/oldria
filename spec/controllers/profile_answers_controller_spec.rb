require 'spec_helper'

describe ProfileAnswersController do
  
  before(:each) do
    current_user = Factory(:user)
    controller.stubs(:current_user).returns current_user
    @profile = Factory(:profile, :user => current_user)
  end

  it "should create a new answer" do
    question = Factory(:profile_question)
    answer = Factory.build(:profile_answer)
    ProfileAnswer.expects(:new).returns(answer)
    answer.expects(:save).returns(true)
    post :create, :profile_answer => { :profile_question_id => question.id, :answer => "Something!" }
    response.should be_redirect
  end

end
