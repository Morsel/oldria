require_relative '../../spec_helper'

describe Admin::HqPromosController do
  integrate_views

  before(:each) do
    @hq_promo = FactoryGirl.create(:hq_promo)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all hq_promo as @hq_promo" do
      HqPromo.stubs(:find).returns([@hq_promo])
      get :index
      assigns[:promos].should == [@hq_promo]
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