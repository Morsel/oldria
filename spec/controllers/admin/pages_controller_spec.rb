require_relative '../../spec_helper'

describe Admin::PagesController do
  integrate_views
  before(:each) do
    FactoryGirl.create(:page)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "GET index" do
    it "should render index template" do
      get :index
      response.should render_template(:index)
    end
  end

  context "GET show" do
    it "should render show template" do
      get :show, :id => Page.first
      response.should render_template(:show)
    end
  end

  context "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  context "POST create" do
    it "should render new template when model is invalid" do
      Page.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "should redirect when model is valid" do
      Page.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(admin_pages_url)
    end
  end

  context "GET edit" do
    it "should render edit template" do
      get :edit, :id => Page.first
      response.should render_template(:edit)
    end
  end

  context "PUT update" do
    it "should render edit template when model is invalid" do
      Page.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Page.first
      response.should render_template(:edit)
    end

    it "should redirect when model is valid" do
      Page.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Page.first
      response.should redirect_to(admin_pages_url(:anchor => "page_#{Page.first.id}"))
    end
  end

  context "DELETE destroy" do
    it "should destroy model and redirect to index action" do
      page = Page.first
      delete :destroy, :id => page
      response.should redirect_to(admin_pages_url)
      Page.exists?(page.id).should be_false
    end
  end
end
