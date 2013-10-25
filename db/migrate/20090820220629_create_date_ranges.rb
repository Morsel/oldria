#encoding: utf-8 
class CreateDateRanges < ActiveRecord::Migration
  def self.up
    create_table :date_ranges do |t|
      t.date :start_date
      t.date :end_date
      t.string :name
      t.timestamps
    end
  end
  
  def self.down
    drop_table :date_ranges
  end
end
