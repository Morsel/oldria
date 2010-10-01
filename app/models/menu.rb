class Menu < ActiveRecord::Base
  belongs_to :pdf_remote_attachment, :class_name => "PDFRemoteAttachment" 
  belongs_to :restaurant

  validates_presence_of :name
  validates_presence_of :pdf_remote_attachment

  accepts_nested_attributes_for :pdf_remote_attachment

  def self.change_frequencies
    @change_frequencies ||= begin
      File.read(File.join(RAILS_ROOT, 'db/seedlings/restaurant_features/menu change tags.txt')).split("\r\n")
    end
  end
  validates_inclusion_of :change_frequency, :in => Menu.change_frequencies, :message => "must be selected"


  def self.from_params(params)
    menu = Menu.new(params)
    menu.save
    menu
  end

end

# == Schema Information
#
# Table name: menus
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  change_frequency     :string(255)
#  remote_attachment_id :integer
#  restaurant_id        :integer
#  created_at           :datetime
#  updated_at           :datetime
#

