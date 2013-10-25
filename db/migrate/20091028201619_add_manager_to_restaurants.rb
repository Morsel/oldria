#encoding: utf-8 
class AddManagerToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :manager_id, :integer
  end

  def self.down
    remove_column :restaurants, :manager_id
  end
end
