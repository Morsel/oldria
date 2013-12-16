require_relative '../spec_helper'

describe ProfileAnswersController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    controller.stubs(:current_user).returns @user
    @profile = FactoryGirl.create(:profile, :user => @user)
    FactoryGirl.create(:default_employment, :employee => @user)
  end

  it "should create a new answer" do
    question = FactoryGirl.create(:profile_question)
    answer = FactoryGirl.build(:profile_answer)
    
    ProfileQuestion.expects(:find).with(question.id).returns(question)
    question.expects(:find_or_build_answer_for).returns(answer)
    answer.expects(:save).returns(true)

    post :create, :user_id => @user.id, :profile_question => { question.id => { :answer => "Something!" }}, :format => "html"
    response.should be_redirect
  end

  it "should let a user update an existing answer" do
    answer = FactoryGirl.create(:profile_answer)
    ProfileAnswer.expects(:find).returns(answer)
    answer.expects(:update_attributes).with("answer" => "Something else!").returns(true)
    put :update, :user_id => @user.id, :id => answer.id, :profile_answer => { :answer => "Something else!" }
    response.should be_redirect
  end

  it "should let a user delete their answer" do
    answer = FactoryGirl.create(:profile_answer)
    ProfileAnswer.expects(:find).returns(answer)
    answer.expects(:destroy).returns(true)
    delete :destroy, :user_id => @user.id, :id => answer.id
    response.should be_redirect
  end

end
