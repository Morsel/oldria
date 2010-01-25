class Feed < ActiveRecord::Base
  attr_reader :feed
  attr_accessible :url, :feed_url, :title, :featured
  named_scope :featured, :conditions => {:featured => true}
  default_scope :order => :position
  acts_as_list

  before_validation_on_create :fetch_and_parse_if_needed

  def fetch_and_parse
    @feed ||= Feedzirra::Feed.fetch_and_parse(feed_url)
    assign_attributes_from_feed
  end

  def assign_attributes_from_feed
    if @feed && @feed.respond_to?(:title)
      self.title = @feed.title
      self.url   = @feed.url
      self.etag  = @feed.etag
      self.last_modified = @feed.last_modified
    end
  end

  private

  def fetch_and_parse_if_needed
    fetch_and_parse if [self.title, self.url].all?(&:blank?)
  end
end
