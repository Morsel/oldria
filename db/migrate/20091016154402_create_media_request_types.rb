#encoding: utf-8 
class CreateMediaRequestTypes < ActiveRecord::Migration
  def self.up
    create_table :media_request_types do |t|
      t.string :name, :shortname
      t.timestamps
    end
  end

  def self.down
    drop_table :media_request_types
  end
end
