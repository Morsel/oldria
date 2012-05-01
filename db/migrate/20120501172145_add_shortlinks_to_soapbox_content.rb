class AddShortlinksToSoapboxContent < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :short_url, :string
    add_column :a_la_minute_answers, :short_url, :string
    add_column :promotions, :short_url, :string
    add_column :soapbox_entries, :short_url, :string
  end

  def self.down
    remove_column :soapbox_entries, :short_url
    remove_column :promotions, :short_url
    remove_column :a_la_minute_answers, :short_url
    remove_column :menu_items, :short_url
  end
end