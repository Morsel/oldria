class AddUserIdToSoapboxTraceKeywords < ActiveRecord::Migration
  def self.up
    add_column :soapbox_trace_keywords, :user_id, :string
  end

  def self.down
    remove_column :soapbox_trace_keywords, :user_id
  end
end
