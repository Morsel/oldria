#encoding: utf-8 
class CreateFeedCategories < ActiveRecord::Migration
  def self.up
    create_table :feed_categories do |t|
      t.string :name
      t.timestamps
    end

    change_table :feeds do |t|
      t.references :feed_category
    end

    add_index :feeds, :feed_category_id
  end

  def self.down
    remove_index :feeds, :feed_category_id

    change_table :feeds do |t|
      t.remove :feed_category_id
    end

    drop_table :feed_categories
  end
end