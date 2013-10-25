#encoding: utf-8 
class AddSortNameToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :sort_name, :string
    Restaurant.all.each do |r|
      r.update_attribute(:sort_name, r.name)
    end
  end

  def self.down
    remove_column :restaurants, :sort_name
  end
end
