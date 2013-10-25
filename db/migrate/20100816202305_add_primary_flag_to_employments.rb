#encoding: utf-8 
class AddPrimaryFlagToEmployments < ActiveRecord::Migration
  def self.up
    add_column :employments, :primary, :boolean, :default => false
  end

  def self.down
    remove_column :employments, :primary
  end
end
