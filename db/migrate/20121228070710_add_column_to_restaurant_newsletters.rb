#encoding: utf-8 
class AddColumnToRestaurantNewsletters < ActiveRecord::Migration
  def self.up
  	add_column :restaurant_newsletters, :introduction, :text
  end

  def self.down
  	remove_column :restaurant_newsletters, :introduction
  end
end
