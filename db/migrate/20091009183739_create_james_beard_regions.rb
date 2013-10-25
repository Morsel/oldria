#encoding: utf-8 
class CreateJamesBeardRegions < ActiveRecord::Migration
  def self.up
    create_table :james_beard_regions do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :james_beard_regions
  end
end
