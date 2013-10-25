#encoding: utf-8 
class RenameRestaurantFeaturesRestaurantsAssociation < ActiveRecord::Migration
  def self.up
    rename_table :restaurant_features_restaurants, :restaurant_feature_items
    add_column :restaurant_feature_items, :id, :primary_key
    add_column :restaurant_feature_items, :top_tag, :boolean, :default => false
  end

  def self.down
    remove_column :restaurant_feature_items, :id
    remove_column :restaurant_feature_items, :top_tag
    
    rename_table :restaurant_feature_items, :restaurant_features_restaurants
  end
end