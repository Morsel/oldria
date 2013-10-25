#encoding: utf-8 
class CreateMediaNewsletterSettings < ActiveRecord::Migration
  def self.up
    create_table :media_newsletter_settings do |t|
    	t.boolean :opt_out, :default => false
    	t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :media_newsletter_settings
  end
end
