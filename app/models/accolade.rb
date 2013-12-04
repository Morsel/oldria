# == Schema Information
# Schema version: 20120217190417
#
# Table name: accolades
#
#  id               :integer         not null, primary key
#  accoladable_id   :integer
#  name             :string(255)     default(""), not null
#  media_type       :string(255)     default(""), not null
#  run_date         :date            not null
#  created_at       :datetime
#  updated_at       :datetime
#  link             :string(255)
#  accoladable_type :string(255)
#

class Accolade < ActiveRecord::Base
  cattr_accessor :valid_media_types
  self.valid_media_types = ['National television exposure',
    'Local television exposure',
    'National press',
    'Significant local press']

  belongs_to :accoladable, :polymorphic => true
  validates_presence_of :name, :run_date
  validates_inclusion_of :media_type, :in => valid_media_types
  validates_format_of :link, :with => /^https?\:\/\//, :allow_blank => true,
    :message => "needs to begin with 'http'. You can copy a URL from the Address bar in your browser"

  scope :by_run_date, :order => "run_date DESC"
  attr_accessible :name, :run_date, :media_type, :link,:accoladable

  def restaurant?
    accoladable.is_a?(Restaurant)
  end

end
