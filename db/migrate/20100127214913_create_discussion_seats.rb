#encoding: utf-8 
class CreateDiscussionSeats < ActiveRecord::Migration
  def self.up
    create_table :discussion_seats do |t|
      t.integer :user_id
      t.integer :discussion_id

      t.timestamps
    end
  end

  def self.down
    drop_table :discussion_seats
  end
end
