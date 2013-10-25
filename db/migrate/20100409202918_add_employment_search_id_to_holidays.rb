#encoding: utf-8 
class AddEmploymentSearchIdToHolidays < ActiveRecord::Migration
  def self.up
    add_column :holidays, :employment_search_id, :integer
  end

  def self.down
    remove_column :holidays, :employment_search_id
  end
end
