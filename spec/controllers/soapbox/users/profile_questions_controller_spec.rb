require_relative '../../../spec_helper'

describe Soapbox::Users::ProfileQuestionsController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all users as @user" do
      get :index,:user_id=> @user.id
      response.should render_template(:index)
    end
  end

  describe "GET show" do
    it "Get show action" do
    	@profile_question = FactoryGirl.create(:profile_question)
      get :show,:user_id=> @user.id,:id=> @profile_question.id
      response.should render_template(:show)
    end
  end

end
