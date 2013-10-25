#encoding: utf-8 
class ChangeRestaurantIsActivatedDefaultValue < ActiveRecord::Migration
  def self.up
  	change_column :restaurants, :is_activated, :boolean, :default=>true
  end

  def self.down
  	change_column :restaurants, :is_activated, :boolean, :default=>false
  end
end
