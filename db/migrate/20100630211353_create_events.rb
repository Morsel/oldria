#encoding: utf-8 
class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :restaurant_id
      t.string :title
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.text :description
      t.string :category
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
