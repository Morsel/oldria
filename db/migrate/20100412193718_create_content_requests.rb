#encoding: utf-8 
class CreateContentRequests < ActiveRecord::Migration
  def self.up
    create_table :content_requests do |t|
      t.string :subject
      t.text :body
      t.datetime :scheduled_at
      t.datetime :expired_at
      t.integer :employment_search_id

      t.timestamps
    end
  end

  def self.down
    drop_table :content_requests
  end
end
