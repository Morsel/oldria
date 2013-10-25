#encoding: utf-8 
class CreateNewSocialPosts < ActiveRecord::Migration
  def self.up
    create_table :social_posts do |t|
      t.string :source_type
      t.integer :source_id
      t.integer :job_id
      t.string :type
      t.text :content
      t.datetime :post_at
      t.timestamps
    end
  end

  def self.down
    drop_table :social_posts
  end
end
