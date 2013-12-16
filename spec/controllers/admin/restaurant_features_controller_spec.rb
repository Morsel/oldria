require_relative '../../spec_helper'

describe Admin::RestaurantFeaturesController do
  include ActionController::RecordIdentifier

  let(:category) { stub(:id => 1, :name => "Category") }
  let(:params) { {"value" => "test", "restaurant_feature_category_id" => 1} }

  before(:each) do
    @user = FactoryGirl.create(:admin)
    @user.stubs(:update).returns(true)
    controller.stubs(:current_user).returns(@user)
  end

  context "POST create" do
    it "should redirect when model is invalid" do
      RestaurantFeature.expects(:new).returns(
          stub(:save => false, :value => "test"))
      post :create, :restaurant_feature => params
      flash[:error].should =~ /invalid/
      response.should redirect_to(admin_restaurant_features_url)
    end

    it "should redirect when model is valid" do
      RestaurantFeature.expects(:new).returns(
          stub(:save => true, :value => "test"))
      post :create, :restaurant_feature => params
      flash[:notice].should =~ /new feature/
      response.should redirect_to(admin_restaurant_features_url)
    end
  end
  
  describe "POST edit_in_place" do

    before(:each) do
      @pretty = RestaurantFeature.create!(:restaurant_feature_category_id => 1, :value => "Pretty")
    end

    it "should return the new text on successful update" do
      RestaurantFeature.expects(:find).returns(@pretty)
      # .with(@pretty.id).returns(@pretty)
      post :edit_in_place, "new_value" => "Very Pretty ", "data" => "false",
          "id" => dom_id(@pretty), "orig_value"=>"Pretty"
      ActiveSupport::JSON.decode(response.body).should == {"is_error" => false,
          "error_text" => nil, "html" => "Very Pretty"}
    end

    it "should return error text on un successful update" do
      RestaurantFeature.expects(:find).returns(@pretty)
      @pretty.expects(:update_attributes).returns(false)
      post :edit_in_place, "new_value" => "Very Pretty ", "data" => "false",
          "id" => dom_id(@pretty), "orig_value"=>"Pretty"
      ActiveSupport::JSON.decode(response.body).should == {"is_error" => true,
          "error_text" => "Error updating feature -- possible duplicate",
          "html" => "Pretty"}
    end
    
  end
  
end