#encoding: utf-8 
class AddConceptToRestaurantFactSheet < ActiveRecord::Migration
  def self.up
    add_column :restaurant_fact_sheets, :concept, :string
  end

  def self.down
    remove_column :restaurant_fact_sheets, :concept
  end
end
