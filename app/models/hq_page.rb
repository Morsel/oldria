class HqPage < ActiveRecord::Base
  include PageFeatures

    validates_presence_of :title
    validates_presence_of :slug
    validates_format_of :slug, :with => /^[\w\d_\-]+$/, :on => :create, :message => "can only contain lowercase letters, numbers, underscores (_) and dashes (-)"
    before_validation :generate_slug!
    before_destroy :deletable? # Prevents accidental deletion of SPECIAL pages

    has_friendly_id :slug
end
