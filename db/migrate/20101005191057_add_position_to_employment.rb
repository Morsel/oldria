#encoding: utf-8 
class AddPositionToEmployment < ActiveRecord::Migration
  def self.up
    add_column :employments, :position, :integer
  end

  def self.down
    remove_column :employments, :position
  end
end
