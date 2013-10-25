#encoding: utf-8 
class CreateUserRestaurantVisitors < ActiveRecord::Migration
  def self.up
    create_table :user_restaurant_visitors do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :user_restaurant_visitors
  end
end
