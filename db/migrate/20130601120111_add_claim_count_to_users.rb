#encoding: utf-8 
class AddClaimCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :claim_count, :integer ,:default=>0
  end

  def self.down
    remove_column :users, :claim_count
  end
end
