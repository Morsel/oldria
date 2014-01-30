require_relative '../spec_helper'

describe CompleteRegistrationsController do
  integrate_views

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end

  describe "GET show" do
    it "should render the show template" do
      get :show
      response.should render_template(:show)
    end
  end

  describe "GET user_details" do
    it "work if invitation is present" do
      @invitation = FactoryGirl.create(:invitation,:invitee_id=>@user.id)
      get :user_details
      response.should render_template(:user_details)
    end
  end

  describe "GET find_restaurant" do
    it "work if restaurant is present" do
      restaurant = FactoryGirl.create(:restaurant)
      get :find_restaurant,:restaurant_name=>restaurant.name
      response.header['Content-Type'].should include 'text/html'
    end
  end

  describe "GET contact_restaurant" do
    it "work if restaurant is present" do
      restaurant = FactoryGirl.create(:restaurant)
      get :contact_restaurant,:restaurant_id=>restaurant.id
      response.should redirect_to(root_path)
    end
  end

  describe "GET finish_without_contact" do
    it "work for finish_without_contact" do
      get :finish_without_contact
      response.should redirect_to(root_path)
    end
  end

end   