#encoding: utf-8 
class CreateRestaurantFactSheets < ActiveRecord::Migration
  def self.up
    create_table :restaurant_fact_sheets do |t|
      t.string :venue
      t.string :intersection
      t.string :neighborhood
      t.string :parking
      t.string :public_transit
      t.string :dinner_average_price
      t.string :lunch_average_price
      t.string :brunch_average_price
      t.string :breakfast_average_price
      t.string :children_average_price
      t.string :small_plate_min_price
      t.string :small_plate_max_price
      t.string :large_plate_min_price
      t.string :large_plate_max_price
      t.string :dessert_plate_min_price
      t.string :dessert_plate_max_price
      t.string :wine_by_the_glass_count
      t.string :wine_by_the_glass_min_price
      t.string :wine_by_the_glass_max_price
      t.string :wine_by_the_bottle_count
      t.string :wine_by_the_bottle_min_price
      t.string :wine_by_the_bottle_max_price
      t.text :wine_by_the_bottle_details
      t.string :reservations
      t.text :cancellation_policy
      t.string :payment_methods
      t.boolean :byob_allowed
      t.string :corkage_fee
      t.string :dress_code
      t.string :delivery
      t.string :wheelchair_access
      t.string :smoking
      t.string :architect_name
      t.string :graphic_designer
      t.string :furniture_designer
      t.string :furniture_manufacturer
      t.text :flooring
      t.text :millwork
      t.text :china
      t.text :kitchen_equipment
      t.text :lighting
      t.text :draperies
      t.string :square_footage
      t.references :restaurant
      t.datetime :parking_and_directions_updated_at
      t.datetime :pricing_updated_at
      t.datetime :guest_relations_updated_at
      t.datetime :design_updated_at
      t.datetime :other_updated_at

      t.timestamps
    end

    Restaurant.all.each do |r|
      r.fact_sheet = RestaurantFactSheet.create
      r.save
    end
  end

  def self.down
    drop_table :restaurant_fact_sheets
  end
end
