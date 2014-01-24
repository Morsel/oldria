require_relative '../../spec_helper'

describe Spoonfeed::PromotionsController do
 integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET index" do
    it "Get index page" do
      get :index
      @promotions = Promotion.from_premium_restaurants.all(:order => "created_at DESC").paginate(:page => 6)
      assigns[:promotions].should == @promotions
      response.should render_template('index')
    end
  end
end   
