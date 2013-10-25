#encoding: utf-8 
class AddPrimaryPhotoIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :primary_photo_id, :integer
  end

  def self.down
    remove_column :restaurants, :primary_photo_id
  end
end
