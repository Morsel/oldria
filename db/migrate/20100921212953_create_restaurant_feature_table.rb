#encoding: utf-8 
class CreateRestaurantFeatureTable < ActiveRecord::Migration
  def self.up
    create_table :restaurant_feature_pages do |t|
      t.string :name
      t.timestamps
    end

    create_table :restaurant_feature_categories do |t|
      t.string :name
      t.integer :restaurant_feature_page_id
      t.timestamps
    end

    create_table :restaurant_features do |t|
      t.integer :restaurant_feature_category_id
      t.string :value
      t.timestamps
    end

    create_table :restaurant_restaurant_features, :id => false do |t|
      t.integer :restaurant_id
      t.integer :restaurant_feature_id
    end
  end

  def self.down
    drop_table :restaurant_restaurant_features
    drop_table :restaurant_features
    drop_table :restaurant_feature_categories
    drop_table :restaurant_feature_pages
  end
end
