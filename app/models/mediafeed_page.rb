# == Schema Information
# Schema version: 20120217190417
#
# Table name: mediafeed_pages
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class MediafeedPage < ActiveRecord::Base
  include PageFeatures
  extend FriendlyId
    validates_presence_of :title
    validates_presence_of :slug
    validates_format_of :slug, :with => /^[\w\d_\-]+$/, :on => :create, :message => "can only contain lowercase letters, numbers, underscores (_) and dashes (-)"
    before_validation :generate_slug!
    before_destroy :deletable? # Prevents accidental deletion of SPECIAL pages

    friendly_id :slug
end
