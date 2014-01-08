require_relative '../spec_helper'

describe TimelinesController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:people_you_follow)
  end

  it "return the timeline of twitter client" do
    get :twitter
    response.should render_template(:activity_stream)
  end
  
  it "return the timeline of facebook client" do
    get :facebook
    response.should render_template(:activity_stream)
  end

  it "return the activity stream" do
    get :activity_stream
    response.should render_template(:activity_stream)
  end
end
