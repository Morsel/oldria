#encoding: utf-8 
class AddSubjectColumnToRestaurantNewsletter < ActiveRecord::Migration
  def self.up
  	add_column :restaurant_newsletters, :subject, :string
  end

  def self.down
  	remove_column :restaurant_newsletters, :subject
  end
end
