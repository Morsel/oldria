#encoding: utf-8 
class CreateSpoonfeedTraceSearches < ActiveRecord::Migration
  def self.up
    create_table :spoonfeed_trace_searches do |t|
      t.integer :searchable_id
      t.string :searchable_type
      t.integer :user_id
      t.string :term_name
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :spoonfeed_trace_searches
  end
end
