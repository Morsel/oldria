#encoding: utf-8 
class AddDefaultToRestaurantsIsActivated < ActiveRecord::Migration
  def self.up
    change_column_default :restaurants, :is_activated, false

    # Set all currently existing restaurants to active
    Restaurant.update_all(:is_activated => true)
  end

  def self.down
    change_column_default :restaurants, :is_activated, nil
  end
end