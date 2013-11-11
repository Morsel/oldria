# == Schema Information
#
# Table name: feed_entries
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  author       :string(255)
#  url          :string(255)
#  summary      :text
#  content      :text
#  published_at :datetime
#  guid         :string(255)
#  feed_id      :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class FeedEntry < ActiveRecord::Base
  attr_accessible :title, :author, :content, :summary, :url, :published_at, :guid
  belongs_to :feed
  default_scope :order => 'published_at DESC'
  acts_as_readable

  validates_uniqueness_of :guid

  before_validation :fill_summary
  # before_validation_on_create :sanitize!
  before_validation :sanitize!, :on => :create

  def sanitize!
    self.summary = Loofah.fragment(summary).text.to_s
    self.content = Loofah.scrub_fragment(content, :prune).to_s
  end

  def fill_summary
    return unless summary.blank?
    self.summary = content
  end

end
