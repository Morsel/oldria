#encoding: utf-8 
class RenameProfileRestaurantsToCulinaryJobs < ActiveRecord::Migration
  def self.up
    if connection.tables.include?("profile_restaurants")
      rename_table :profile_restaurants, :culinary_jobs
    end
  end

  def self.down
    if connection.tables.include?("culinary_jobs")
      rename_table :culinary_jobs, :profile_restaurants
    end
  end
end