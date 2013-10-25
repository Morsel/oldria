#encoding: utf-8 
class RestaurantBasicData < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :description, :string, :length => 250
    add_column :restaurants, :phone_number, :string
    add_column :restaurants, :website, :string
    add_column :restaurants, :twitter_username, :string
    add_column :restaurants, :facebook_page, :string
    add_column :restaurants, :hours, :string
  end

  def self.down
    remove_column :restaurants, :hours
    remove_column :restaurants, :facebook_page
    remove_column :restaurants, :twitter_username
    remove_column :restaurants, :website
    remove_column :restaurants, :phone_number
    remove_column :restaurants, :description
  end
end
