require_relative '../spec_helper'

describe Admin::FeedsController do
  integrate_views
  before(:each) do
    Factory(:feed, :no_entries => true)
    @user = Factory(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => Feed.first
    response.should render_template(:show)
  end

  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Feed.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Feed.any_instance.stubs(:save).returns(true)
    post :create
    response.should redirect_to(admin_feeds_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => Feed.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Feed.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Feed.first
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    Feed.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Feed.first
    response.should redirect_to(admin_feeds_url)
  end

  it "destroy action should destroy model and redirect to index action" do
    feed = Feed.first
    delete :destroy, :id => feed
    response.should redirect_to(admin_feeds_url)
    Feed.exists?(feed.id).should be_false
  end

  it "sort action should respond to js" do
    post :sort, :feeds => []
    response.should be_success
  end
end
