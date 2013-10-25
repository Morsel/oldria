#encoding: utf-8 
class CreateMeals < ActiveRecord::Migration
  def self.up
    create_table :meals do |t|
      t.string :name
      t.string :day
      t.string :open_at_hours
      t.string :open_at_minutes
      t.string :open_at_am_pm
      t.string :closed_at_hours
      t.string :closed_at_minutes
      t.string :closed_at_am_pm
      t.references :restaurant_fact_sheet

      t.timestamps
    end
  end

  def self.down
    drop_table :meals
  end
end
