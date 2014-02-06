require_relative '../../spec_helper'

describe Admin::HqPromosController do
  integrate_views

  before(:each) do
    @hq_slide = FactoryGirl.create(:hq_slide)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all hq_slide as @hq_slide" do
      HqSlide.stubs(:find).returns([@hq_slide])
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET sort" do
    it "sort" do
      get :sort
      response.should be_success
    end
  end

end  