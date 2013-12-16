require_relative '../../spec_helper'

describe Admin::FeedCategoriesController do
  integrate_views
  before(:each) do
    @feed_category = FactoryGirl.create(:feed_category)
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
      get :show, :id => FeedCategory.first
      response.should render_template(:show)
    end
  end

  context "GET new" do
    it "should render new template" do
      get :new
      response.should render_template(:new)
    end
  end

  context "GET edit" do
    it "should render edit template" do
      get :edit, :id => FeedCategory.first
      response.should render_template(:edit)
    end
  end

  context "POST create" do
    it "should render new template when model is invalid" do
      FeedCategory.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end

    it "should redirect when model is valid" do
      FeedCategory.any_instance.stubs(:valid?).returns(true)
      post :create
      response.should redirect_to(admin_feed_categories_path)
    end
  end

  context "PUT update" do
    it "should render edit template when model is invalid" do
      FeedCategory.any_instance.stubs(:valid?).returns(false)
      put :update, :id => FeedCategory.first
      response.should render_template(:edit)
    end

    it "should redirect when model is valid" do
      FeedCategory.any_instance.stubs(:valid?).returns(true)
      put :update, :id => FeedCategory.first
      response.should redirect_to(admin_feed_categories_path)
    end
  end

  context "DELETE destroy" do
    it "should destroy model and redirect to index action" do
      feed_category = FeedCategory.first
      delete :destroy, :id => feed_category
      response.should redirect_to(admin_feed_categories_path)
      FeedCategory.exists?(feed_category.id).should be_false
    end
  end
end
