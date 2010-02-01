class Feed < ActiveRecord::Base
  attr_accessible :url, :feed_url, :title, :featured
  named_scope :featured, :conditions => ['featured=?', true]
  default_scope :order => :position
  has_many :feed_entries

  has_many :feed_subscriptions
  has_many :users, :through => :feed_subscriptions

  acts_as_list

  after_validation_on_create :fetch_and_parse_if_needed

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

  def assign_attributes_from_feed
    if feed && feed.respond_to?(:title)
      self.title = feed.title
      self.url   = feed.url
      self.etag  = feed.etag
      self.last_modified = feed.last_modified
    end
  end

  def update_entries!
    return unless needs_update?
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

  def self.update_all_entries!
    self.all.each {|f| f.update_entries! }
  end

  private

  def fetch_and_parse_if_needed
    fetch_and_parse if title.blank? && url.blank?
  end
end
