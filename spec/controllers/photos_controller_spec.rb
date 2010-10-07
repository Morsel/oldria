require 'spec_helper'

#Processing PhotosController#reorder (for 127.0.0.1 at 2010-10-06 16:47:44) [POST]
#Parameters: {"photo"=>["73", "74", "71"], "action"=>"reorder", "authenticity_token"=>"JJRQF2nRBEQfvHKs7/kInm9e+4bYm4uOgw0fG2ZUHro=", "controller"=>"photos", "restaurant_id"=>"16"}

describe PhotosController do
  describe "GET reorder" do
    let :restaurant do
      restaurant = Factory(:restaurant)
      3.times {restaurant.photos << Factory(:photo)}
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
