require_relative '../../spec_helper'
module Soapbox
	describe RestaurantFeaturesController do
	  it "index action should render show template" do
	  	@restaurant_feature = FactoryGirl.create(:restaurant_feature)
	    get :show,:id=>@restaurant_feature.id
	  end
	end
end