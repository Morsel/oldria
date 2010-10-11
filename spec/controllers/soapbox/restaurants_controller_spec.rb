require 'spec/spec_helper'

describe Soapbox::RestaurantsController do

  describe "GET show" do

    let(:restaurant) { Factory(:restaurant) }

    describe "premium" do

      it "should work fine" do
        restaurant.update_attributes(:premium_account => true)
        get :show, :id => restaurant.id
        response.should be_success
      end

    end

    describe "not premium" do
      
      it "redirects to the home page" do
        restaurant.update_attributes(:premium_account => false)
        get :show, :id => restaurant.id
        response.should redirect_to(soapbox_index_url)
      end

    end

  end


end