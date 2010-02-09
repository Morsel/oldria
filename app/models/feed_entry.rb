class FeedEntry < ActiveRecord::Base
  belongs_to :feed
  default_scope :order => 'published_at DESC'
  acts_as_readable

  validates_uniqueness_of :guid

  before_validation :fill_summary
  before_validation_on_create :sanitize!

  def sanitize!
    self.summary = Loofah.fragment(summary).text.to_s
    self.content = Loofah.scrub_fragment(content, :prune).to_s
  end

  def fill_summary
    return unless summary.blank?
    self.summary = content
  end

end
