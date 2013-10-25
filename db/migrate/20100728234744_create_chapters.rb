#encoding: utf-8 
class CreateChapters < ActiveRecord::Migration
  def self.up
    create_table :chapters do |t|
      t.integer :topic_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :chapters
  end
end
