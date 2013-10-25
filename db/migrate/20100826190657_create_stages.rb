#encoding: utf-8 
class CreateStages < ActiveRecord::Migration
  def self.up
    create_table :stages do |t|
      t.string :establishment
      t.string :expert
      t.date :start_date
      t.date :end_date
      t.text :comments
      t.integer :profile_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stages
  end
end
