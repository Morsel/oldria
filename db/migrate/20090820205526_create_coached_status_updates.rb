#encoding: utf-8 
class CreateCoachedStatusUpdates < ActiveRecord::Migration
  def self.up
    create_table :coached_status_updates do |t|
      t.string :message
      t.string :time_of_year
      t.timestamps
    end
  end
  
  def self.down
    drop_table :coached_status_updates
  end
end
