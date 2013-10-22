# == Schema Information
# Schema version: 20120217190417
#
# Table name: soapbox_pages
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class SoapboxPage < ActiveRecord::Base

  include PageFeatures
 	extend FriendlyId
  validates_presence_of :title
  validates_presence_of :slug
  validates_format_of :slug, :with => /^[\w\d_\-]+$/, :on => :create, :message => "can only contain lowercase letters, numbers, underscores (_) and dashes (-)"
  before_validation :generate_slug!
  before_destroy :deletable? # Prevents accidental deletion of SPECIAL pages

  #has_friendly_id :slug
  #has_friendly_id :slug, :use_slug => true
    friendly_id :slug#, use: :slugged

end
