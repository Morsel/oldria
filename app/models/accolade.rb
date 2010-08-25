class Accolade < ActiveRecord::Base
  cattr_accessor :valid_media_types
  self.valid_media_types = ['National television exposure',
    'Local television exposure',
    'National press',
    'Significant local press']

  belongs_to :profile
  validates_presence_of :name, :run_date
  validates_inclusion_of :media_type, :in => valid_media_types
  validates_format_of :link, :with => /^https?\:\/\//, :allow_blank => true,
    :message => "needs to begin with 'http'. You can copy a URL from the Address bar in your browser"
end
