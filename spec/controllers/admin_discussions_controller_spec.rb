require_relative '../spec_helper'

describe AdminDiscussionsController do
  integrate_views
  before do
    fake_normal_user
    @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
    @trend_question = FactoryGirl.create(:trend_question)
    @admin_discussion = AdminDiscussion.create!(:restaurant => @restaurant, :discussionable => @trend_question)
  end

  it "show action should render show template" do
    get :show, :id => AdminDiscussion.first
    response.should be_success
  end

  it "show action should render show template" do
    get :read, :id => AdminDiscussion.first
    response.should be_success
  end
  
end
