#encoding: utf-8 
class AddFacebookExpirationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_token_expiration, :datetime
  end

  def self.down
    remove_column :users, :facebook_token_expiration
  end
end
