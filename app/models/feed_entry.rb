class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  default_scope :order => 'published_at DESC'
  validates_uniqueness_of :guid
end
