#encoding: utf-8 
class CreateTastingMenus < ActiveRecord::Migration
  def self.up
    create_table :tasting_menus do |t|
      t.string :name
      t.string :price
      t.string :wine_supplement_price
      t.references :restaurant_fact_sheet

      t.timestamps
    end
  end

  def self.down
    drop_table :tasting_menus
  end
end
