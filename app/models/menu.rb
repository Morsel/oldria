class Menu < ActiveRecord::Base
  belongs_to :remote_attachment
  belongs_to :restaurant

  accepts_nested_attributes_for :remote_attachment

  def self.change_frequencies
    @change_frequencies ||= begin
      File.read(File.join(RAILS_ROOT, 'db/seedlings/restaurant_features/menu change tags.txt')).split("\r\n")
    end
  end

  def self.from_params!(params)
    remote_attachment = RemoteAttachment.create!(:attachment => params.delete(:attachment))
    menu = Menu.create!(params)
    menu.update_attributes!(:remote_attachment => remote_attachment)
    menu
  end
  
end
