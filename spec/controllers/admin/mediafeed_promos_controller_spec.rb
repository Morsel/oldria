require_relative '../../spec_helper'

describe Admin::MediafeedPromosController do
  integrate_views

  before(:each) do
    @mediafeed_promo = FactoryGirl.create(:mediafeed_promo)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "assigns all mediafeed_promo as @mediafeed_promo" do
      HqPromo.stubs(:find).returns([@mediafeed_promo])
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