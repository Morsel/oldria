#encoding: utf-8 
class AddMetroAndRegionToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :metropolitan_area_id, :integer
    add_column :profiles, :james_beard_region_id, :integer
  end

  def self.down
    remove_column :profiles, :james_beard_region_id
    remove_column :profiles, :metropolitan_area_id
  end
end
