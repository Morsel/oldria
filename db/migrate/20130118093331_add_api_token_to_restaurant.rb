#encoding: utf-8 
class AddApiTokenToRestaurant < ActiveRecord::Migration
  def self.up
  	add_column :restaurants, :api_token, :string
  	Restaurant.all.each do |restaurant|
  		restaurant.update_attribute(:api_token,  Digest::SHA1.hexdigest(restaurant.id.to_s))
  	end
  end

  def self.down
  	remove_column :restaurants, :api_token
  end
end
