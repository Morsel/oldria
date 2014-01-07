require_relative '../spec_helper'

describe LogosController do
  integrate_views

  before(:each) do
    @restaurant = FactoryGirl.create(:restaurant)
  end

  describe "DELETE destroy" do
    it "destroys the requested restaurant" do
      Restaurant.expects(:find).with("37").returns(@restaurant)
      @restaurant.logo.expects(:destroy)
      #delete :destroy, :id => "37"
    end

    it "redirects to the restaurant list" do
      Restaurant.stubs(:find).returns(@restaurant)
      delete :destroy, :id => "1"
      response.should  redirect_to(edit_restaurant_url(@restaurant))
    end
  end

end
