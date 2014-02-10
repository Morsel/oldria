require_relative '../../spec_helper'
module Soapbox
  describe Soapbox::RestaurantsController do
  integrate_views

  before(:each) do
    @restaurant = FactoryGirl.create(:restaurant)
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:require_admin).returns(true)
  end
  
  it "Work for show condition" do
    get  :show,:id => @restaurant.id 
    response.should be_redirect
  end

  describe "GET show" do

    let(:restaurant) { FactoryGirl.create(:restaurant) }

    describe "premium" do

      it "should work fine" do
        restaurant.subscription = FactoryGirl.create(:subscription)
        get :show, :id => restaurant.id
        response.should be_success
      end

    end

    describe "not premium" do

      it "redirects to the home page" do
        get :show, :id => restaurant.id
        response.should redirect_to(soapbox_root_url)
      end

    end

  end

  describe "subscribing to a restaurant's newsletter" do

    before(:each) do
      @restaurant = FactoryGirl.create(:restaurant)
      @subscriber = FactoryGirl.create(:newsletter_subscriber)
      
      # MailchimpConnector.stubs(:new).returns(mc = mock)
      # mc.stubs(:client).returns(client = mock)
      # mc.stubs(:mailing_list_id).returns(1234)

      # client.stubs(:list_interest_groupings).returns("#{@restaurant.name} in #{@restaurant.city} #{@restaurant.state}")
      # client.stubs(:list_update_member).returns(true)
    end

    it "should allow a newsletter subscriber to remove a restaurant subscription" do
      cookies['newsletter_subscriber_id'] = @subscriber.id
      NewsletterSubscription.create(:restaurant => @restaurant, :newsletter_subscriber => @subscriber)
      NewsletterSubscription.count.should == 1

      post :unsubscribe, :id => @restaurant.id, :subscriber_id => @subscriber.id
      NewsletterSubscription.count.should == 0
    end

  end

  end
end 