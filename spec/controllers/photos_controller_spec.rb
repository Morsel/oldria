require_relative '../spec_helper'

describe PhotosController do
  describe "GET reorder" do
    let :restaurant do
      restaurant = Factory(:restaurant)
      3.times {restaurant.photos << Factory(:photo)}

      @user = Factory(:user)
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
  end
end
