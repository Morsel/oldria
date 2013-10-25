#encoding: utf-8 
class CreateDiscussions < ActiveRecord::Migration
  def self.up
    create_table :discussions do |t|
      t.string :title
      t.text :body
      t.integer :poster_id
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :discussions
  end
end
