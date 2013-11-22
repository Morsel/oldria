# == Schema Information
# Schema version: 20120217190417
#
# Table name: subject_matters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  general    :boolean
#  fields     :string(255)
#  private    :boolean
#

class SubjectMatter < ActiveRecord::Base
  has_many :responsibilities, :dependent => :destroy
  has_many :employments, :through => :responsibilities
  has_many :media_requests

  validates_presence_of :name
  default_scope :order => "#{table_name}.name ASC"

  scope :nongeneral, :conditions => ["general IS NULL OR general = ?", false]
  scope :general, :conditions => ["general IS NULL OR general = ?", true]
  scope :media_viewable, :conditions => ["private IS NULL or private = ?", false]
  attr_accessible :name,:general,:private


  def admin_only?
    name =~ /RIA/ # || private?
  end

  # Returns a parameterized array of strings
  # from the comma separated list of field names
  # For example, if fields is "Jimmy Dean, Little girl"
  # fieldset will return # => ['jimmy_dean', 'little_girl']
  def fieldset
    @fieldset = (fields || "").split(/, */).map do |field|
      field.gsub(/\s+/, '_').downcase
    end
  end

  def self.for_select
    self.media_viewable.nongeneral.all.map { |sm| [sm.name, sm.id] }
  end
end
