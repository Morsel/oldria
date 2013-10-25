#encoding: utf-8 
class CreateEmploymentSearches < ActiveRecord::Migration
  def self.up
    create_table :employment_searches do |t|
      t.text :conditions

      t.timestamps
    end
  end

  def self.down
    drop_table :employment_searches
  end
end
