require_relative '../../spec_helper'
module Soapbox

  describe PhotosController do
    integrate_views
      describe "GET index" do
        it "Get index" do
          @restaurant = FactoryGirl.create(:restaurant)
          get :index ,:restaurant_id=>@restaurant.id
          response.should render_template(:index)
        end
      end

      describe "GET show" do
        it "Get show" do
          @photo = FactoryGirl.create(:photo)
          @restaurant = FactoryGirl.create(:restaurant)
          get :index ,:restaurant_id=>@restaurant.id,:id=>@photo.id
        end
      end

  end 



end 