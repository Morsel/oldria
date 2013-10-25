#encoding: utf-8 
class AddGeographicAssociationsToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :metropolitan_area_id, :integer
    add_column :restaurants, :james_beard_region_id, :integer
  end

  def self.down
    remove_column :restaurants, :james_beard_region_id
    remove_column :restaurants, :metropolitan_area_id
  end
end
