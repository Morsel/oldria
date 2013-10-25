#encoding: utf-8 
class CreateProfileOutOfDates < ActiveRecord::Migration
  def self.up
    create_table :profile_out_of_dates do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :profile_out_of_dates
  end
end
