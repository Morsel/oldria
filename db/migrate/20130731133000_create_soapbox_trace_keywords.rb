#encoding: utf-8 
class CreateSoapboxTraceKeywords < ActiveRecord::Migration
  def self.up
    create_table :soapbox_trace_keywords do |t|
      t.integer :keywordable_id
      t.string :keywordable_type
      t.integer :count

      t.timestamps
    end
  end

  def self.down
    drop_table :soapbox_trace_keywords
  end
end
