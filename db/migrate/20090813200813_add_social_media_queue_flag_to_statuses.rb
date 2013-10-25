#encoding: utf-8 
class AddSocialMediaQueueFlagToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :queue_for_social_media, :boolean
  end

  def self.down
    remove_column :statuses, :queue_for_social_media
  end
end
