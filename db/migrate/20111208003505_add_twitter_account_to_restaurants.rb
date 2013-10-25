#encoding: utf-8 
class AddTwitterAccountToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :atoken, :string
    add_column :restaurants, :asecret, :string
  end

  def self.down
    remove_column :restaurants, :asecret
    remove_column :restaurants, :atoken
  end
end
