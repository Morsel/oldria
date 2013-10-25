#encoding: utf-8 
class AddOpenDateToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :opening_date, :date
  end

  def self.down
    remove_column :restaurants, :opening_date
  end
end
