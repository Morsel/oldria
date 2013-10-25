#encoding: utf-8 
class AddOmniscientToEmployments < ActiveRecord::Migration
  def self.up
    add_column :employments, :omniscient, :boolean
  end

  def self.down
    remove_column :employments, :omniscient
  end
end
