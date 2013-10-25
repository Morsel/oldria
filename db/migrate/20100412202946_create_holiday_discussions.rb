#encoding: utf-8 
class CreateHolidayDiscussions < ActiveRecord::Migration
  def self.up
    create_table :holiday_discussions do |t|
      t.integer :restaurant_id
      t.integer :holiday_id
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :holiday_discussions
  end
end
