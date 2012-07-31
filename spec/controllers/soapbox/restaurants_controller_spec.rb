require 'spec/spec_helper'

describe Soapbox::RestaurantsController do
  describe "GET show" do

    let(:restaurant) { Factory(:restaurant) }

    describe "premium" do

      it "should work fine" do
        restaurant.subscription = Factory(:subscription)
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

    it "should allow a newsletter subscriber to add a restaurant subscription" do
      restaurant = Factory(:restaurant)
      subscriber = Factory(:newsletter_subscriber)
      cookies['newsletter_subscriber_id'] = subscriber.id
      post :subscribe, :id => restaurant.id
      NewsletterSubscription.count.should == 1
    end
  end

end