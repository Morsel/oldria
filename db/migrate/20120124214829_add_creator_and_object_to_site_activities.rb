#encoding: utf-8 
class AddCreatorAndObjectToSiteActivities < ActiveRecord::Migration
  def self.up
    add_column :site_activities, :creator_id, :integer
    add_column :site_activities, :creator_type, :string
    add_column :site_activities, :content_id, :integer
    add_column :site_activities, :content_type, :string
  end

  def self.down
    remove_column :site_activities, :content_type
    remove_column :site_activities, :content_id
    remove_column :site_activities, :creator_type
    remove_column :site_activities, :creator_id
  end
end
