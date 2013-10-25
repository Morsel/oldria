#encoding: utf-8 
class FeatureIndexes < ActiveRecord::Migration
  def self.up
    add_index :restaurant_features, [:restaurant_feature_category_id],
        :name => "restaurant_feature_category_id_index"
    add_index :restaurant_feature_categories, [:restaurant_feature_page_id],
        :name => "restaurant_feature_page_id_index"
    add_index :restaurant_features_restaurants, [:restaurant_feature_id],
        :name => "restaurant_feature_id_index"
    add_index :restaurant_features_restaurants, [:restaurant_id],
        :name => "restaurant_id_index"
    add_index :restaurant_features_restaurants, [:restaurant_id, :restaurant_feature_id],
        :name => "_restaurant_id_restaurant_feature_id_index"
  end

  def self.down
    remove_index :restaurant_features, :restaurant_feature_category_id_index
    remove_index :restaurant_feature_categories, :restaurant_feature_page_id_index
    remove_index :restaurant_features_restaurants, :restaurant_feature_id_index
    remove_index :restaurant_features_restaurants, :restaurant_id_index
    remove_index :restaurant_features_restaurants, :_restaurant_id_restaurant_feature_id_index
  end
end
