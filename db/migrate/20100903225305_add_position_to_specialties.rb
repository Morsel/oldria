#encoding: utf-8 
class AddPositionToSpecialties < ActiveRecord::Migration
  def self.up
    add_column :specialties, :position, :integer
  end

  def self.down
    remove_column :specialties, :position
  end
end
