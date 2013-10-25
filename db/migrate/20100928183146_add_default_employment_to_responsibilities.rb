#encoding: utf-8 
class AddDefaultEmploymentToResponsibilities < ActiveRecord::Migration
  def self.up
    add_column :responsibilities, :default_employment_id, :integer
  end

  def self.down
    remove_column :responsibilities, :default_employment_id
  end
end
