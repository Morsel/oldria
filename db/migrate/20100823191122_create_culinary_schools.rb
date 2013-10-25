#encoding: utf-8 
class CreateCulinarySchools < ActiveRecord::Migration
  def self.up
    create_table :culinary_schools do |t|
      t.string :name, :city, :state, :country, :default => '', :null => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :culinary_schools
  end
end
