#encoding: utf-8 
class CreateMediafeedPages < ActiveRecord::Migration
  def self.up
    create_table :mediafeed_pages do |t|
      t.string :title
      t.string :slug
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :mediafeed_pages
  end
end
