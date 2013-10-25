#encoding: utf-8 
class AddIsActivateToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :is_activated, :boolean
  end

  def self.down
    remove_column :restaurants, :is_activated
  end
end
