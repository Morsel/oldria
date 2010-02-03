class CreateFeedCategories < ActiveRecord::Migration
  def self.up
    create_table :feed_categories do |t|
      t.string :name
      t.timestamps
    end

    change_table :feeds do |t|
      t.references :feed_category
    end

    add_index :feed_categories, :id, :unique => true
    add_index :feeds, :feed_category_id
    add_index :feeds, :id, :unique => true
  end

  def self.down
    remove_index :feeds, :id
    remove_index :feeds, :feed_category_id
    remove_index :feed_categories, :column => :id

    change_table :feeds do |t|
      t.remove :feed_category_id
    end

    drop_table :feed_categories
  end
end