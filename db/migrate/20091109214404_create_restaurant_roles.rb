#encoding: utf-8 
class CreateRestaurantRoles < ActiveRecord::Migration
  def self.up
    create_table :restaurant_roles do |t|
      t.string :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :restaurant_roles
  end
end
