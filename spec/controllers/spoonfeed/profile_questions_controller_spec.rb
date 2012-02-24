require 'spec_helper'

describe Spoonfeed::ProfileQuestionsController do

  before(:each) do
    @user = Factory(:user)
    controller.stubs(:current_user).returns(@user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      question = Factory(:profile_question)
      get 'show', :id => question.id
      response.should be_success
    end
  end
end
