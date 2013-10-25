#encoding: utf-8 
class AddNewsletterFlagToNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :receive_soapbox_news, :boolean, :default => true
  end

  def self.down
    remove_column :newsletter_subscribers, :receive_soapbox_news
  end
end
