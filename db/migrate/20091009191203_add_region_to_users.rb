#encoding: utf-8 
class AddRegionToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :james_beard_region_id, :integer
  end

  def self.down
    remove_column :users, :james_beard_region_id
  end
end
