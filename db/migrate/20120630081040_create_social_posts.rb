#encoding: utf-8 
class CreateSocialPosts < ActiveRecord::Migration
  def self.up
    create_table :social_posts do |t|
      t.string :post_data
      t.string :link
      t.datetime :post_created_at
      t.string :source
      t.integer :restaurant_id
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :social_posts
  end
end
