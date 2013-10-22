# == Schema Information
#
# Table name: feeds
#
#  id               :integer         not null, primary key
#  url              :string(255)
#  feed_url         :string(255)
#  title            :string(255)
#  etag             :string(255)
#  featured         :boolean
#  position         :integer         default(0)
#  last_modified    :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  feed_category_id :integer
#

class Feed < ActiveRecord::Base
  attr_accessible :url, :feed_url, :title, :featured, :feed_category_id
  scope :featured, :conditions => ['featured=?', true]
  scope :uncategorized, :conditions => {:feed_category_id => nil}
  default_scope :order => :position
  belongs_to :feed_category
  has_many :feed_entries, :dependent => :destroy

  has_many :feed_subscriptions, :dependent => :destroy
  has_many :users, :through => :feed_subscriptions

  acts_as_list :scope => :feed_category

  before_create :normalize_feed_url
  before_validation :fetch_and_parse_if_needed, :on => :create
  # after_validation_on_create :fetch_and_parse_if_needed
  after_create :update_entries

  attr_accessor :no_entries

  def feed
    @feed ||= fetch_feed
  end

  def fetch_and_parse
    fetch_feed
    assign_attributes_from_feed
  end

  def fetch_feed
    Feedzirra::Feed.fetch_and_parse(feed_url)
  end

  def normalize_feed_url
    return unless feed_url
    self.feed_url = feed_url.gsub(/^feed\:\/\//,'http://')
  end

  def assign_attributes_from_feed
    if feed && feed.respond_to?(:title)
      self.title = feed.title
      self.url   = feed.url
      self.etag  = feed.etag
      self.last_modified = feed.last_modified
    end
  end

  def update_entries
    return if self.no_entries || !needs_update?
    update_entries!
  end

  def update_entries!
    feed.entries.each do |entry|
      next if FeedEntry.exists?(:guid => entry.id)
      self.feed_entries.create(
        :title        => entry.title,
        :author       => entry.author,
        :content      => entry.content,
        :summary      => entry.summary,
        :url          => entry.url,
        :published_at => entry.published,
        :guid         => entry.id
      )
    end
    self.etag = feed.etag
    self.last_modified = feed.last_modified
  end

  def needs_update?
    # If the etag isn't the same, or if it's out of date, or if it has no entries
    self.etag != feed.etag || self.last_modified < feed.last_modified || self.feed_entries.empty?
  end

  # Class methods to update everybody, conservatively or aggressivelycucum
  def self.update_all_entries
    self.all.each {|f| f.update_entries }
  end

  def self.update_all_entries!
    self.all.each {|f| f.update_entries! }
  end

  private

  def fetch_and_parse_if_needed
    fetch_and_parse if title.blank? && url.blank?
  end
end
