#encoding: utf-8 
class AddTwitterTokensToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :atoken, :string
    add_column :users, :asecret, :string
  end

  def self.down
    remove_column :users, :asecret
    remove_column :users, :atoken
  end
end
