require_relative '../../spec_helper'
module Soapbox

describe FeaturePagesController do

  integrate_views

    describe "GET show" do
      it "Render the template show" do
        @restaurant = FactoryGirl.create(:restaurant)
        @restaurant_feature_page = FactoryGirl.create(:restaurant_feature_page)
        get :show ,:restaurant_id=>@restaurant.id,:id=>@restaurant_feature_page.id
        response.should render_template('feature_pages/show')
      end
    end
  end 

end