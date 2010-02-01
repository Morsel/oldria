class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  default_scope :order => 'published_at DESC'
  acts_as_readable

  validates_uniqueness_of :guid
end
