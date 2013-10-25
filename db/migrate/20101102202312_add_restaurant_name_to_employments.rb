#encoding: utf-8 
class AddRestaurantNameToEmployments < ActiveRecord::Migration
  def self.up
    # for default employments only
    add_column :employments, :solo_restaurant_name, :string
  end

  def self.down
    remove_column :employments, :solo_restaurant_name
  end
end
