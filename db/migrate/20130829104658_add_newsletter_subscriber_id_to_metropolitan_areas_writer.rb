class AddNewsletterSubscriberIdToMetropolitanAreasWriter < ActiveRecord::Migration
  def self.up
    add_column :metropolitan_areas_writers, :newsletter_subscriber_id, :integer,:null => true
  end

  def self.down
    remove_column :metropolitan_areas_writers, :newsletter_subscriber_id
  end
end
