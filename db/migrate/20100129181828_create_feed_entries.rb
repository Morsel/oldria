#encoding: utf-8 
class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string :title, :author, :url
      t.text :summary, :content
      t.datetime :published_at
      t.string :guid
      t.references :feed

      t.timestamps
    end
  end

  def self.down
    drop_table :feed_entries
  end
end
