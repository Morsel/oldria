#encoding: utf-8 
class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.text :facts
      t.timestamps
    end
  end
  
  def self.down
    drop_table :restaurants
  end
end
