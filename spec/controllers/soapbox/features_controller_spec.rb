require_relative '../../spec_helper'
describe Soapbox::FeaturesController do

  integrate_views

    describe "GET show" do
      it "Render the template show" do
        @restaurant_feature = FactoryGirl.create(:restaurant_feature)
        get :show ,:id=>@restaurant_feature.id
        response.should render_template('features/show')
      end
    end

end 	
