#encoding: utf-8 
class AddTagLineToRestaurant < ActiveRecord::Migration
  def self.up
  	add_column :restaurants, :tag_line, :string
  end

  def self.down
  	remove_column :restaurants, :tag_line
  end
end
