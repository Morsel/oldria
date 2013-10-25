#encoding: utf-8 
class CreateHqPages < ActiveRecord::Migration
  def self.up
    create_table :hq_pages do |t|
      t.string :title
      t.string :slug
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :hq_pages
  end
end
