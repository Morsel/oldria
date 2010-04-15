# == Schema Information
#
# Table name: pages
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  title      :string(255)
#  slug       :string(255)
#  content    :text
#

class Page < ActiveRecord::Base
  SPECIAL = %w(about contact first_time_users welcome_new_user sales home)

  validates_presence_of :title
  validates_presence_of :slug
  validates_format_of :slug, :with => /^[\w\d_\-]+$/, :on => :create, :message => "can only contain lowercase letters, numbers, underscores (_) and dashes (-)"
  before_validation :generate_slug!
  before_destroy :deletable? # Prevents accidental deletion of SPECIAL pages

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
