class Page < ActiveRecord::Base
  SPECIAL = %w(welcome_new_user about contact)

  validates_presence_of :title
  validates_presence_of :slug
  before_validation :generate_slug!

  has_friendly_id :slug

  def generate_slug!
    return slug unless slug.blank?
    self.slug = Slug.normalize(title)
  end

  def deletable?
    not special?
  end

  def special?
    SPECIAL.include?(slug)
  end
end
