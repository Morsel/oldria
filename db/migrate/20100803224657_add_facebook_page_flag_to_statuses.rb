#encoding: utf-8 
class AddFacebookPageFlagToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :queue_for_facebook_page, :boolean, :default => false
    add_column :statuses, :facebook_page_id, :integer
  end

  def self.down
    remove_column :statuses, :queue_for_facebook_page
    remove_column :statuses, :facebook_page_id
  end
end
