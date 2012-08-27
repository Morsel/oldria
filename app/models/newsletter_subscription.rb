# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id                       :integer         not null, primary key
#  restaurant_id            :integer
#  newsletter_subscriber_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#  share_with_restaurant    :boolean         default(FALSE)
#

class NewsletterSubscription < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :newsletter_subscriber

  validates_uniqueness_of :newsletter_subscriber_id, :scope => :restaurant_id

  after_create :add_subscription_to_mailchimp
  after_destroy :remove_subscription_from_mailchimp

  private

  def add_subscription_to_mailchimp
    unless newsletter_subscriber.opt_out?
      mc = MailchimpConnector.new
      group_name = "#{restaurant.name} in #{restaurant.city} #{restaurant.state}"
      unless mc.client.list_interest_groupings(:id => mc.mailing_list_id).to_s.match(/#{group_name}/)
        mc.client.list_interest_group_add(:id => mc.mailing_list_id, :group_name => group_name)
      end

      mc.client.list_update_member(:id => mc.mailing_list_id, :email_address => newsletter_subscriber.email,
                                   :merge_vars => { :groupings => [{ :name => "Your Interests", :groups => group_name}] },
                                   :replace_interests => false)
    end
  end

  def remove_subscription_from_mailchimp
    groups = []
    groups << "National Newsletter" if newsletter_subscriber.receive_soapbox_news?
    for subscription in newsletter_subscriber.newsletter_subscriptions
      groups << "#{subscription.restaurant.name} in #{subscription.restaurant.city} #{subscription.restaurant.state}" unless subscription == self
    end

    mc = MailchimpConnector.new
    mc.client.list_update_member(:id => mc.mailing_list_id, :email_address => newsletter_subscriber.email,
                                 :merge_vars => { :groupings => [{ :name => "Your Interests", :groups => groups.join(",")}] },
                                 :replace_interests => true)
  end

end
