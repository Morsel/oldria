#encoding: utf-8 
class CreateSiteActivities < ActiveRecord::Migration
  def self.up
    create_table :site_activities do |t|
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :site_activities
  end
end
