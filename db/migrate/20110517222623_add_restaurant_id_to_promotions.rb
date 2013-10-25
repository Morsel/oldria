#encoding: utf-8 
class AddRestaurantIdToPromotions < ActiveRecord::Migration
  def self.up
    add_column :promotions, :restaurant_id, :integer
  end

  def self.down
    remove_column :promotions, :restaurant_id
  end
end
