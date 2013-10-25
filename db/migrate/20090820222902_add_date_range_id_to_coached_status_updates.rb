#encoding: utf-8 
class AddDateRangeIdToCoachedStatusUpdates < ActiveRecord::Migration
  def self.up
    change_table :coached_status_updates do |t|
      t.remove :time_of_year
      t.references :date_range
    end
  end

  def self.down
    change_table :coached_status_updates do |t|
      t.string :time_of_year
      t.remove :date_range_id
    end
  end
end
