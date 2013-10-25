#encoding: utf-8 
class AddSourceIdToSocialPosts < ActiveRecord::Migration
  def self.up
    add_column :social_posts, :post_id, :string
  end

  def self.down
    remove_column :social_posts, :post_id
  end
end
