#encoding: utf-8 
class CreateSeatingAreas < ActiveRecord::Migration
  def self.up
    create_table :seating_areas do |t|
      t.string :name
      t.integer :occupancy
      t.references :restaurant_fact_sheet

      t.timestamps
    end
  end

  def self.down
    drop_table :seating_areas
  end
end
