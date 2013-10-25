#encoding: utf-8 
class AddFieldsToMediaRequestTypes < ActiveRecord::Migration
  def self.up
    add_column :media_request_types, :fields, :string
  end

  def self.down
    remove_column :media_request_types, :fields
  end
end
