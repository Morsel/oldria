#encoding: utf-8 
class CreateNonculinarySchools < ActiveRecord::Migration
  def self.up
    create_table :nonculinary_schools do |t|
      t.string :name, :city, :state, :country, :default => '', :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :nonculinary_schools
  end
end
