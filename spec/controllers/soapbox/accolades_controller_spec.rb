require_relative '../../spec_helper'

describe AccoladesController do
  integrate_views
  include Soapbox
  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end
  
  shared_examples_for Soapbox do
    describe "GET index" do
      it "GET index" do
        @restaurant = FactoryGirl.create(:restaurant)
        get :index ,:restaurant_id => @restaurant.id
        assigns[:restaurant].should == @restaurant
      end
    end
  end   

end
