#encoding: utf-8 
class AddTitleToSoapboxTraceKeyword < ActiveRecord::Migration
  def self.up
    add_column :soapbox_trace_keywords, :title, :string
  end

  def self.down
    remove_column :soapbox_trace_keywords, :title
  end
end
