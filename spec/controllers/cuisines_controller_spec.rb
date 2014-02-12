require_relative '../spec_helper'

describe CuisinesController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  it "index action should render index template" do
    get :index
    @request.env['HTTP_ACCEPT'] = 'text/javascript'
    response.body.should == " "
  end

  it "auto_complete_cuisines action should render auto_complete_cuisines template" do
    get :auto_complete_cuisines
    @request.env['HTTP_ACCEPT'] = 'text/javascript'
    response.should be_success
  end

end   