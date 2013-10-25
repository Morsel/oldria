#encoding: utf-8 
class AddClosedDaysToRestaurantFactSheet < ActiveRecord::Migration
  def self.up
    add_column :restaurant_fact_sheets, :days_closed, :string
    add_column :restaurant_fact_sheets, :holidays_closed, :string
  end

  def self.down
    remove_column :restaurant_fact_sheets, :days_closed
    remove_column :restaurant_fact_sheets, :holidays_closed
  end
end
