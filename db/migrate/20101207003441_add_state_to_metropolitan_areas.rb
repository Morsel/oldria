#encoding: utf-8 
class AddStateToMetropolitanAreas < ActiveRecord::Migration
  def self.up
    add_column :metropolitan_areas, :state, :string
  end

  def self.down
    remove_column :metropolitan_areas, :state
  end
end
