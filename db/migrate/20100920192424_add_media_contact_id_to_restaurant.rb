  #encoding: utf-8 
class AddMediaContactIdToRestaurant < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :media_contact_id, :integer
  end

  def self.down
    remove_column :restaurants, :media_contact_id
  end
end
