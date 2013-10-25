#encoding: utf-8 
class CreateTraceSearches < ActiveRecord::Migration
  def self.up
    create_table :trace_searches do |t|
      t.integer :searchable_id
      t.string :searchable_type
      t.integer :user_id
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :trace_searches
  end
end
