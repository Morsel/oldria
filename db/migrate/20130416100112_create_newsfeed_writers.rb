#encoding: utf-8 
class CreateNewsfeedWriters < ActiveRecord::Migration
  def self.up
    create_table :newsfeed_writers do |t|
      t.string :name

      t.timestamps
    end
    NewsfeedWriter.create({:name=>"National Writer"})
    NewsfeedWriter.create({:name=>"Regional Writer"})
    NewsfeedWriter.create({:name=>"Local Writer"})
  end

  def self.down
    drop_table :newsfeed_writers
  end
end
