#encoding: utf-8 
class AddCampaignIdToRestaurantNewsletter < ActiveRecord::Migration
  def self.up
    add_column :restaurant_newsletters, :campaign_id, :string
  end

  def self.down
    remove_column :restaurant_newsletters, :campaign_id
  end
end
