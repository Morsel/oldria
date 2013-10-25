#encoding: utf-8 
class AddPositionToTopics < ActiveRecord::Migration
  def self.up
    add_column :topics, :position, :integer
  end

  def self.down
    remove_column :topics, :position
  end
end
