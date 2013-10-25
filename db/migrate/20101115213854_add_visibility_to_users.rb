#encoding: utf-8 
class AddVisibilityToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :visible, :boolean, :default => true
  end

  def self.down
    remove_column :users, :visible
  end
end
