#encoding: utf-8 
class AddFacebookAccessTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_access_token, :string
  end

  def self.down
    remove_column :users, :facebook_access_token
  end
end
