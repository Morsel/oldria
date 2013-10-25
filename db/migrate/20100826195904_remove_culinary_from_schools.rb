#encoding: utf-8 
class RemoveCulinaryFromSchools < ActiveRecord::Migration
  def self.up
    remove_column :schools, :culinary
  end

  def self.down
    add_column :schools, :culinary, :boolean
  end
end
