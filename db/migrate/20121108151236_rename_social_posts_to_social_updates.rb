#encoding: utf-8 
class RenameSocialPostsToSocialUpdates < ActiveRecord::Migration
  def self.up
    rename_table :social_posts, :social_updates
  end

  def self.down
    rename_table :social_updates, :social_posts
  end
end
