#encoding: utf-8 
class CreateRegionalWriters < ActiveRecord::Migration
  def self.up
    create_table :regional_writers do |t|
    	t.string  :regional_writer_type
    	t.integer :regional_writer_id
      t.integer :user_id
      t.integer :james_beard_region_id

      t.timestamps
    end
  end

  def self.down
    drop_table :regional_writers
  end
end
