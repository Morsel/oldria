#encoding: utf-8 
class AddRestaurantRoleToEmployments < ActiveRecord::Migration
  def self.up
    add_column :employments, :restaurant_role_id, :integer
  end

  def self.down
    remove_column :employments, :restaurant_role_id
  end
end
