#encoding: utf-8 
class AddUrlToSoapboxTraceKeyword < ActiveRecord::Migration
  def self.up
    add_column :soapbox_trace_keywords, :url, :string
  end

  def self.down
    remove_column :soapbox_trace_keywords, :url
  end
end
