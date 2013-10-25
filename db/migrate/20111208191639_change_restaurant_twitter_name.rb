#encoding: utf-8 
class ChangeRestaurantTwitterName < ActiveRecord::Migration
  def self.up
    rename_column :restaurants, :twitter_username, :twitter_handle
  end

  def self.down
    rename_column :restaurants, :twitter_handle, :twitter_username
  end
end