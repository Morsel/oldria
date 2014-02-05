require_relative '../spec_helper'

describe RiaWebservicesController do
  integrate_views

  before(:each) do
    @mediafeed_page = FactoryGirl.create(:mediafeed_page)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET api_register" do
    it "api_register" do
      get :api_register
      response.should be_success
    end
    it "work if diner get on params" do
      get :api_register,:role=>"diner"
      response.should be_success
    end
  end





end 
