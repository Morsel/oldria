class AddDigestDinerIdToNewsletterSubscriber < ActiveRecord::Migration
  def self.up
    add_column :newsletter_subscribers, :digest_diner_id, :integer,:null => true
  end

  def self.down
    remove_column :newsletter_subscribers, :digest_diner_id
  end
end
