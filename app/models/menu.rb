# == Schema Information
# Schema version: 20120217190417
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

  # default_scope :order => "menus.position, menus.created_at DESC"

  scope :by_position, :order => "menus.position, menus.created_at DESC"
  scope :activated_restaurants, lambda {
    {
      :joins => 'INNER JOIN restaurants as r ON `r`.id = restaurant_id ',
      :conditions => ["(r.is_activated = ?)",true]
    }
  }
  attr_accessible :restaurant,:name,:change_frequency, :pdf_remote_attachment_attributes,:attachment
  def self.change_frequencies
    @change_frequencies ||= begin
      File.read(File.join(Rails.root, 'db/seedlings/restaurant_features/menu change tags.txt')).split("\r\n")
    end
  end

  validates_inclusion_of :change_frequency, :in => Menu.change_frequencies,
      :message => "must be selected"

  def activity_name
    "menu"
  end

end

