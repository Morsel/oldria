require File.dirname(__FILE__) + '/../spec_helper'

describe MediaSearchesController do
  integrate_views

  before do
    controller.stubs(:current_user).returns(Factory(:media_user))
  end

  describe "GET show" do
    context "with no search params" do
      before do
        get :show
      end

      it { response.should be_success }

      it "should have a search form" do
        response.should have_selector("form", :action => media_search_path, :method => 'get')
      end
    end

    context "with search params" do
      before do
        @restaurant = Factory(:restaurant, :name => "Long John Silver's", :id => 3)
        user = Factory(:user, :name => "John Smith")
        @employment = Factory(:employment, :restaurant => @restaurant, :employee => user)
        get :show, :search => { :restaurant_name_like => "Long" }
      end

      it { response.should be_success }

      it "should assign @employments" do
        assigns[:employments].should == [@employment]
      end

    end
  end
end
