class AddCountToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :count, :integer
  end

  def self.down
    remove_column :restaurants, :count
  end
end
