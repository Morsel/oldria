#encoding: utf-8 
class CreateProfileRestaurants < ActiveRecord::Migration
  def self.up
    create_table :profile_restaurants do |t|
      t.integer :profile_id, :null => false
      t.string :restaurant_name, :title, :city, :state, :country, :default => "", :null => false
      t.date :date_started, :null => false
      t.date :date_ended
      t.string :chef_name, :default => "", :null => false
      t.boolean :chef_is_me, :default => false, :null => false
      t.text :cuisine, :notes, :default => "", :null => false

      t.timestamps
    end
    add_index :profile_restaurants, :profile_id
  end

  def self.down
    remove_index :profile_restaurants, :profile_id
    drop_table :profile_restaurants
  end
end