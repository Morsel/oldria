require_relative '../../spec_helper'

describe Admin::RestaurantFeatureCategoriesController do
  include ActionController::RecordIdentifier

  let(:page) { stub(:id => 1, :name => "Page") }
  let(:params) { {"name" => "test", "restaurant_feature_page_id" => 1} }

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "POST create" do
    it "should redirect when model is invalid" do
      RestaurantFeatureCategory.expects(:new).returns(stub(:save => false, :name => "test"))
          #.with(params).returns(stub(:save => false, :name => "test"))
      post :create, :restaurant_feature_category => params
      flash[:error].should =~ /invalid/
      response.should redirect_to(admin_restaurant_features_url)
    end

    it "should redirect when model is valid" do
      RestaurantFeatureCategory.expects(:new).returns(stub(:save => true, :name => "test"))
      # .with(params).returns(stub(:save => true, :name => "test"))
      post :create, :restaurant_feature_category => params
      flash[:notice].should =~ /new category/
      response.should redirect_to(admin_restaurant_features_url)
    end
  end

  describe "POST edit_in_place" do

    before(:each) do
      @menu = RestaurantFeatureCategory.create!(:restaurant_feature_page_id => 1,
          :name => "Menu")
    end

    it "should return the new text on successful update" do
      RestaurantFeatureCategory.expects(:find).with(@menu.id).returns(@menu)
      post :edit_in_place, "new_value" => "Menu Style ", "data" => "false",
          "id" => dom_id(@menu), "orig_value"=>"Pretty"
      ActiveSupport::JSON.decode(response.body) == {"is_error" => false, "error_text" => nil,
          "html" => "Menu Style"}
    end

    it "should return error text on un successful update" do
      RestaurantFeatureCategory.expects(:find).with(@menu.id).returns(@menu)
      @menu.expects(:update_attributes).returns(false)
      post :edit_in_place, "new_value" => "Very Pretty ", "data" => "false",
          "id" => dom_id(@menu), "orig_value"=>"Pretty"
      ActiveSupport::JSON.decode(response.body).should == {"is_error" => true,
          "error_text" => "Error updating category -- possible duplicate",
          "html" => "Menu"}
    end

  end
end