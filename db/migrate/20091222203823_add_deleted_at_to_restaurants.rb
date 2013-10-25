#encoding: utf-8 
class AddDeletedAtToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :deleted_at, :datetime
  end

  def self.down
    remove_column :restaurants, :deleted_at
  end
end
