#encoding: utf-8 
class AddPositionToChapters < ActiveRecord::Migration
  def self.up
    add_column :chapters, :position, :integer, :default => 0
  end

  def self.down
    remove_column :chaopters, :position
  end
end
