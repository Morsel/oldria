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


end