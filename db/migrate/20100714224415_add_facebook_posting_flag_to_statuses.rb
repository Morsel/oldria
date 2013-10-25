#encoding: utf-8 .
#encoding: utf-8 
class AddFacebookPostingFlagToStatuses < ActiveRecord::Migration
  def self.up
    add_column :statuses, :queue_for_facebook, :boolean
  end

  def self.down
    remove_column :statuses, :queue_for_facebook
  end
end
