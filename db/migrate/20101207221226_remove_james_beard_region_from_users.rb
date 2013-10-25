#encoding: utf-8 
class RemoveJamesBeardRegionFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :james_beard_region_id
  end

  def self.down
    add_column :users, :james_beard_region_id, :integer
  end
end
