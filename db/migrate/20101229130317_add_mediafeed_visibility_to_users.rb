#encoding: utf-8 
class AddMediafeedVisibilityToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mediafeed_visible, :boolean, :default => true
  end

  def self.down
    remove_column :users, :mediafeed_visible
  end
end
