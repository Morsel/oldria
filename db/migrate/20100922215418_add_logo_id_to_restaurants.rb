#encoding: utf-8 
class AddLogoIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :logo_id, :integer
  end

  def self.down
    remove_column :restaurants, :logo_id
  end
end
