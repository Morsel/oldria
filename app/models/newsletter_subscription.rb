# == Schema Information
# Schema version: 20120731175904
#
# Table name: newsletter_subscriptions
#
#  id                       :integer         not null, primary key
#  restaurant_id            :integer
#  newsletter_subscriber_id :integer
#  created_at               :datetime
#  updated_at               :datetime
#  share_with_restaurant    :boolean
#

class NewsletterSubscription < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :newsletter_subscriber

  validates_uniqueness_of :newsletter_subscriber_id, :scope => :restaurant_id

end
