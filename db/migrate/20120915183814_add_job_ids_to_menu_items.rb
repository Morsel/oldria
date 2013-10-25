#encoding: utf-8 
class AddJobIdsToMenuItems < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :twitter_job_id, :integer
    add_column :menu_items, :facebook_job_id, :integer
  end

  def self.down
    remove_column :menu_items, :twitter_job_id
    remove_column :menu_items, :facebook_job_id
  end
end
