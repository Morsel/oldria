#encoding: utf-8 
class AddEntertainmentToRestaurantFactSheet < ActiveRecord::Migration
  def self.up
    add_column :restaurant_fact_sheets, :entertainment, :string
  end

  def self.down
    remove_column :restaurant_fact_sheets, :entertainment
  end
end
