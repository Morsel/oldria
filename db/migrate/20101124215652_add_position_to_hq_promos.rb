#encoding: utf-8 
class AddPositionToHqPromos < ActiveRecord::Migration
  def self.up
    add_column :hq_promos, :position, :integer
  end

  def self.down
    remove_column :hq_promos, :position
  end
end
