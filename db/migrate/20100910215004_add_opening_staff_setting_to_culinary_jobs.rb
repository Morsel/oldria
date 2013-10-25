#encoding: utf-8 
class AddOpeningStaffSettingToCulinaryJobs < ActiveRecord::Migration
  def self.up
    add_column :culinary_jobs, :opening_staff, :boolean, :default => false
  end

  def self.down
    remove_column :culinary_jobs, :opening_staff
  end
end
