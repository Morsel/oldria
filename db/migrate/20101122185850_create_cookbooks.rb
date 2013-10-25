#encoding: utf-8 
class CreateCookbooks < ActiveRecord::Migration
  def self.up
    create_table :cookbooks do |t|
      t.string :title
      t.string :publisher
      t.datetime :published_on
      t.integer :profile_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :cookbooks
  end
end
