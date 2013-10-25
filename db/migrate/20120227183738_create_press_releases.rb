#encoding: utf-8 
class CreatePressReleases < ActiveRecord::Migration
  def self.up
    create_table :press_releases do |t|
      t.string :title
      t.integer :pdf_remote_attachment_id
      t.integer :restaurant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :press_releases
  end
end
