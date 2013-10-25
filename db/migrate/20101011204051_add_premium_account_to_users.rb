#encoding: utf-8 
class AddPremiumAccountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :premium_account, :boolean
  end

  def self.down
    remove_column :users, :premium_account
  end
end