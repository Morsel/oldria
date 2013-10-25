#encoding: utf-8 
class DropExtendedProfileItems < ActiveRecord::Migration
  def self.up
    if connection.tables.include?('extended_profile_items')
      drop_table :extended_profile_items
    end
  end

  def self.down
    unless connection.tables.include?('extended_profile_items')
      create_table "extended_profile_items", :force => true do |t|
        t.integer  "profile_id"
        t.string   "category"
        t.text     "content"
        t.timestamps
      end
    end
  end

end
