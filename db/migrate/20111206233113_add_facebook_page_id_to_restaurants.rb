#encoding: utf-8 
class AddFacebookPageIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :facebook_page_id, :string
    add_column :restaurants, :facebook_page_token, :string
  end

  def self.down
    remove_column :restaurants, :facebook_page_token
    remove_column :restaurants, :facebook_page_id
  end
end
