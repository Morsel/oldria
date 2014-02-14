require_relative '../spec_helper'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
describe PhotosController do
  integrate_views

  before(:each) do
   # @photo = FactoryGirl.create(:photo)
  end

  describe "GET reorder" do
    let :restaurant do

      restaurant = FactoryGirl.create(:restaurant)
      3.times {restaurant.photos << FactoryGirl.create(:photo)}

      @user = FactoryGirl.create(:user)
      controller.stubs(:current_user).returns(@user)
      controller.stubs(:require_admin).returns(false)

      user = @user
      restaurant.managers << user
      employment = restaurant.employments.find_by_employee_id(user.id)
      employment.update_attribute(:omniscient, true)
      restaurant
    end

    it "change order of photos" do
      photos = restaurant.photos
      new_photo_order = [photos[1].id.to_s, photos[2].id.to_s, photos[0].id.to_s]

      get :reorder, :photo => new_photo_order, :restaurant_id => restaurant.id.to_s

      restaurant_with_reordered_photos = Restaurant.find(restaurant.id)
      restaurant_with_reordered_photos.photos.map(&:id).map(&:to_s).should == new_photo_order
    end

    it "maintain order of photos" do
      photos = restaurant.photos
      photo_order = [photos[0].id.to_s, photos[1].id.to_s, photos[2].id.to_s]

      get :reorder, :photo => photo_order, :restaurant_id => restaurant.id.to_s

      restaurant_with_reordered_photos = Restaurant.find(restaurant.id)
      restaurant_with_reordered_photos.photos.map(&:id).map(&:to_s).should == photo_order
    end

    it "no photos" do
      photos = restaurant.photos
      photos.clear
      photo_order = []

      get :reorder, :photo => photo_order, :restaurant_id => restaurant.id.to_s

      restaurant_with_reordered_photos = Restaurant.find(restaurant.id)
      restaurant_with_reordered_photos.photos.map(&:id).map(&:to_s).should == photo_order
    end


    it "index action should render index template" do
      get :index,:restaurant_id=>restaurant.id
      response.should render_template(:index)
    end

    it "edit action should render edit template" do
      photo = FactoryGirl.create(:photo)
      get :edit, :id => Photo.first
      response.should render_template(:action=> "edit")
    end

    it "update action should render edit template when model is invalid" do
      photo = FactoryGirl.create(:photo)
      Photo.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Photo.first
      response.should render_template(:action=> "edit")
    end

    it "show_sizes" do
      photo = FactoryGirl.create(:photo)
      put :show_sizes, :id => Photo.first
      response.should be_success
    end
  end
end
