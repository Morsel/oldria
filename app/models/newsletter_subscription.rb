# == Schema Information
# Schema version: 20120730212805
#
# Table name: newsletter_subscriptions
#
#  id                       :integer         not null, primary key
#  restaurant_id            :integer
#  newsletter_subscriber_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#

class NewsletterSubscription < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :newsletter_subscriber

end
