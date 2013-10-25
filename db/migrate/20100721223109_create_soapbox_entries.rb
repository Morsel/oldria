#encoding: utf-8 
class CreateSoapboxEntries < ActiveRecord::Migration
  def self.up
    create_table :soapbox_entries do |t|
      t.datetime :published_at
      t.references :featured_item, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :soapbox_entries
  end
end
