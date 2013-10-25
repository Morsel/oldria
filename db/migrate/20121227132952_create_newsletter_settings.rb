#encoding: utf-8 
class CreateNewsletterSettings < ActiveRecord::Migration
  def self.up
    create_table :newsletter_settings do |t|
    	t.string :introduction
    	t.references :restaurant

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_settings
  end
end
