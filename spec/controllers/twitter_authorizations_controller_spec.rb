require_relative '../spec_helper'

describe TwitterAuthorizationsController  do
  integrate_views
  before(:each) do
    fake_admin_user
    FactoryGirl.create(:admin_message, :type => 'Admin::PrTip')
  end

  it "new action should render new template" do
  	restaurant = FactoryGirl.create(:restaurant)
    get :new,:restaurant_id=>restaurant.id
    response.should be_redirect
  end

  it "show action should render show template" do
  	restaurant = FactoryGirl.create(:restaurant)
    get :show,:restaurant_id=>restaurant.id
    response.should be_redirect
  end


end   