require_relative '../../spec_helper'

describe Restaurants::NewslettersController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    @restaurant = FactoryGirl.create(:restaurant, :manager => @user)
  end

  it "should allow the manager to view the newsletters page" do
    get :index, :restaurant_id => @restaurant.id
  end

end
