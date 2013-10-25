#encoding: utf-8 
class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string :url
      t.string :feed_url
      t.string :title
      t.string :etag
      t.boolean :featured
      t.integer :position, :default => 0
      t.datetime :last_modified
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
