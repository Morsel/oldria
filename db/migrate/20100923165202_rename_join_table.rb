#encoding: utf-8 
class RenameJoinTable < ActiveRecord::Migration
  def self.up
    rename_table("restaurant_restaurant_features", "restaurant_features_restaurants")
  end

  def self.down
    rename_table("restaurant_features_restaurants", "restaurant_restaurant_features")
  end
end
