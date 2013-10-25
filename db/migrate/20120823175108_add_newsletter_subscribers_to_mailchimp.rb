#encoding: utf-8 
class AddNewsletterSubscribersToMailchimp < ActiveRecord::Migration
  def self.up
    mc = MailchimpConnector.new
    mc.client.listInterestGroupAdd(:id => mc.mailing_list_id, :group_name => "National Newsletter")
    for subscriber in NewsletterSubscriber.confirmed
      mc.client.list_subscribe(:id => mc.mailing_list_id, :email_address => subscriber.email, :double_optin => false,
                               :merge_vars => { :fname => subscriber.first_name, :lname => subscriber.last_name,
                                                :groupings => [{ :name => "Your Interests", :groups => "National Newsletter" }] })
    end
  end

  def self.down
  end
end
