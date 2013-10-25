#encoding: utf-8 
class AddPremiumAccountToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :premium_account, :boolean
  end

  def self.down
    remove_column :restaurants, :premium_account
  end
end
