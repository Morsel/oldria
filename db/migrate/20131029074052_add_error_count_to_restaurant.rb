class AddErrorCountToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :error_count, :integer
  end

  def self.down
    remove_column :restaurants, :error_count
  end
end
