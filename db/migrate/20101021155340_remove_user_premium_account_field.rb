#encoding: utf-8 
class RemoveUserPremiumAccountField < ActiveRecord::Migration
  def self.up
    # remove_column :users, :premium_account
    # remove_column :restaurants, :premium_account
  end
  
  def self.down
    # add_column :users, :premium_account, :boolean
    # add_column :restaurants, :premium_account, :boolean
  end

end
