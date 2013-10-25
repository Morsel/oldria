#encoding: utf-8 
class CreateMetropolitanAreas < ActiveRecord::Migration
  def self.up
    create_table :metropolitan_areas do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :metropolitan_areas
  end
end
