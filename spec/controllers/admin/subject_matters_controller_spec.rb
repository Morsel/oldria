require_relative '../spec_helper'

describe Admin::SubjectMattersController do
  integrate_views
  before(:each) do
    @user = Factory.stub(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    Factory(:subject_matter)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => SubjectMatter.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    SubjectMatter.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    SubjectMatter.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(admin_subject_matters_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => SubjectMatter.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    SubjectMatter.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SubjectMatter.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    SubjectMatter.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SubjectMatter.first
    response.should redirect_to(admin_subject_matters_url)
  end

  it "destroy action should destroy model and redirect to index action" do
    subject_matter = SubjectMatter.first
    delete :destroy, :id => subject_matter
    response.should redirect_to(admin_subject_matters_url)
    SubjectMatter.exists?(subject_matter.id).should be_false
  end
end
