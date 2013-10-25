#encoding: utf-8 
class CreatePageViews < ActiveRecord::Migration
  def self.up
    create_table :page_views do |t|
      t.integer :user_id
      t.string :title
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :page_views
  end
end
