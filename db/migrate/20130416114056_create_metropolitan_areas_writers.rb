#encoding: utf-8 
class CreateMetropolitanAreasWriters < ActiveRecord::Migration
  def self.up
    create_table :metropolitan_areas_writers do |t|
    	t.string  :area_writer_type
    	t.integer :area_writer_id
      t.integer :user_id
      t.integer :metropolitan_area_id
    	
      t.timestamps 
    end
  end

  def self.down
    drop_table :metropolitan_areas_writers
  end
end
