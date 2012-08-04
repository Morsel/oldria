class CreateWpBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :wp_blog_posts do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :wp_blog_posts
  end
end
