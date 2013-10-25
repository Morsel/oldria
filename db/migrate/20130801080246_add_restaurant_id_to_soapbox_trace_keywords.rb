#encoding: utf-8 
class AddRestaurantIdToSoapboxTraceKeywords < ActiveRecord::Migration
  def self.up
    add_column :soapbox_trace_keywords, :restaurant_id, :integer
  end

  def self.down
    remove_column :soapbox_trace_keywords, :restaurant_id
  end
end
