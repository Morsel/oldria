require_relative '../spec_helper'

describe FrontBurnerController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "user_qotds" do
    get :user_qotds,:id=>@user.id
    response.should render_template(:user_qotds)
  end

  it "qotd" do
    get :qotd,:id=>@user.id
    response.should be_success
  end  

end
