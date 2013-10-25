#encoding: utf-8 
class AddColumnToUserRestaurantVisitor < ActiveRecord::Migration
 def self.up
  	add_column :user_restaurant_visitors, :user_id, :integer, :default => false
  	add_column :user_restaurant_visitors, :restaurant_id, :integer, :default => false
  	add_column :user_restaurant_visitors, :visitor_count, :integer, :default => 0
  end

  def self.down
  	remove_column :user_restaurant_visitors, :user_id
  	remove_column :user_restaurant_visitors, :restaurant_id
  	remove_column :user_restaurant_visitors, :visitor_count
  end
end
