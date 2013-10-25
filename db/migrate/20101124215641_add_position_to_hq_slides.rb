#encoding: utf-8 
class AddPositionToHqSlides < ActiveRecord::Migration
  def self.up
    add_column :hq_slides, :position, :integer
  end

  def self.down
    remove_column :hq_slides, :position
  end
end
