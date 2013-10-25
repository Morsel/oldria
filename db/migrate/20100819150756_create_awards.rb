#encoding: utf-8 
class CreateAwards < ActiveRecord::Migration
  def self.up
    create_table :awards do |t|
      t.references :profile
      t.string :name
      t.string :year_won, :year_nominated, :null => false, :default => '', :limit => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :awards
  end
end
