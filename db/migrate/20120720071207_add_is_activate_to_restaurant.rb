class AddIsActivateToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :is_activated, :boolean,:default => false   
    #Restaurant.update_all("is_activated = true")
    execute "UPDATE restaurants set is_activated = true" 
  end

  def self.down
    remove_column :restaurants, :is_activated
  end
end
