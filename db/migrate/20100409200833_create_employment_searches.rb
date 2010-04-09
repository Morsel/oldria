class CreateEmploymentSearches < ActiveRecord::Migration
  def self.up
    create_table :employment_searches do |t|
      t.string :conditions

      t.timestamps
    end
  end

  def self.down
    drop_table :employment_searches
  end
end
