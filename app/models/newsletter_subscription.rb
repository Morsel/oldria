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

end
