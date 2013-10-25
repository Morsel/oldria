#encoding: utf-8 
class AddFieldsToStages < ActiveRecord::Migration
  def self.up
    add_column :stages, :location, :string
  end

  def self.down
    remove_column :stages, :location
  end
end
