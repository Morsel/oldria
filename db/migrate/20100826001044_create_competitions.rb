#encoding: utf-8 
class CreateCompetitions < ActiveRecord::Migration
  def self.up
    create_table :competitions do |t|
      t.integer :profile_id
      t.string :name
      t.string :place
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :competitions
  end
end
