#encoding: utf-8 
class ChangeFbPageUrlOnRestaurants < ActiveRecord::Migration
  def self.up
    rename_column :restaurants, :facebook_page, :facebook_page_url
  end

  def self.down
    rename_column :restaurants, :facebook_page_url, :facebook_page
  end
end