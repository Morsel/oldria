class AddNewsletterSubscriberIdToRegionalWriter < ActiveRecord::Migration
  def self.up
    add_column :regional_writers, :newsletter_subscriber_id, :integer,:null => true
  end

  def self.down
    remove_column :regional_writers, :newsletter_subscriber_id
  end
end
