require_relative '../../spec_helper'

describe Admin::RestaurantFeaturePagesController do
  include ActionController::RecordIdentifier

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "POST create" do
    it "should redirect when model is invalid" do
      RestaurantFeaturePage.expects(:new).with("name" => "test").returns(
          stub(:save => false, :name => "test"))
      post :create, :restaurant_feature_page => {:name => "test"}
      flash[:error].should =~ /invalid/
      response.should redirect_to(admin_restaurant_features_url)
    end

    it "should redirect when model is valid" do
      RestaurantFeaturePage.any_instance.stubs(:valid?).returns(true)
      RestaurantFeaturePage.expects(:new).with("name" => "test").returns(
          stub(:save => true, :name => "test"))
      post :create, :restaurant_feature_page => {:name => "test"}
      flash[:notice].should =~ /new page/
      response.should redirect_to(admin_restaurant_features_url)
    end
  end

  describe "POST edit_in_place" do

    before(:each) do
      @page = RestaurantFeaturePage.create!(:name => "Cuisine")
    end

    it "should return the new text on successful update" do
      RestaurantFeaturePage.expects(:find).with(@page.id).returns(@page)
      post :edit_in_place, "new_value" => "Food", "data" => "false",
          "id" => dom_id(@page), "orig_value" => "Cuisine"
      ActiveSupport::JSON.decode(response.body) == {"is_error" => false, "error_text" => nil,
          "html" => "Food"}
    end

    it "should return error text on unsuccessful update" do
      RestaurantFeaturePage.expects(:find).with(@page.id).returns(@page)
      @page.expects(:update_attributes).returns(false)
      post :edit_in_place, "new_value" => "Very Pretty ", "data" => "false",
          "id" => dom_id(@page), "orig_value"=>"Pretty"
      ActiveSupport::JSON.decode(response.body).should == {"is_error" => true,
          "error_text" => "Error updating page -- possible duplicate",
          "html" => "Cuisine"}
    end

  end
end