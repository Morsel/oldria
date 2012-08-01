class AddIsActivateToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :is_activated, :boolean,:default => false 
  end

  def self.down
    remove_column :restaurants, :is_activated
  end
end
