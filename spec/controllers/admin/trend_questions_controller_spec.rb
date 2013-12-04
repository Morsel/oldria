require_relative '../spec_helper'

describe Admin::TrendQuestionsController do
  integrate_views
  before(:each) do
    fake_admin_user
    Factory(:trend_question)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => TrendQuestion.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    TrendQuestion.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    TrendQuestion.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(admin_trend_question_path(assigns[:trend_question]))
  end

  it "edit action should render edit template" do
    get :edit, :id => TrendQuestion.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    TrendQuestion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => TrendQuestion.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    TrendQuestion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => TrendQuestion.first
    response.should redirect_to(admin_trend_question_path(assigns[:trend_question]))
  end

  it "destroy action should destroy model and redirect to index action" do
    admin_trend_question = TrendQuestion.first
    delete :destroy, :id => admin_trend_question
    response.should redirect_to(admin_trend_questions_url)
    TrendQuestion.exists?(admin_trend_question.id).should be_false
  end
end
