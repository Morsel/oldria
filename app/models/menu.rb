# == Schema Information
# Schema version: 20101207221226
#
# Table name: menus
#
#  id                       :integer         not null, primary key
#  name                     :string(255)
#  change_frequency         :string(255)
#  pdf_remote_attachment_id :integer
#  restaurant_id            :integer
#  created_at               :datetime
#  updated_at               :datetime
#  position                 :integer
#

class Menu < ActiveRecord::Base
  belongs_to :pdf_remote_attachment
  belongs_to :restaurant

  validates_presence_of :name
  validates_presence_of :pdf_remote_attachment

  accepts_nested_attributes_for :pdf_remote_attachment

  default_scope :order => :position

  named_scope :by_position, :order => :position

  def self.change_frequencies
    @change_frequencies ||= begin
      File.read(File.join(RAILS_ROOT, 'db/seedlings/restaurant_features/menu change tags.txt')).split("\r\n")
    end
  end

  validates_inclusion_of :change_frequency, :in => Menu.change_frequencies,
      :message => "must be selected"

end

