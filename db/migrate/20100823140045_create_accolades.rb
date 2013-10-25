#encoding: utf-8 
class CreateAccolades < ActiveRecord::Migration
  def self.up
    create_table :accolades do |t|
      t.references :profile
      t.string :name, :media_type, :default => '', :null => false
      t.date :run_date, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :accolades
  end
end
