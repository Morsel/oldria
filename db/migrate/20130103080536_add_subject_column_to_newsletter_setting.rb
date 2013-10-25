#encoding: utf-8 
class AddSubjectColumnToNewsletterSetting < ActiveRecord::Migration
  def self.up
  	add_column :newsletter_settings, :subject, :string
  end

  def self.down
  	remove_column :newsletter_settings, :subject
  end
end
