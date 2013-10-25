# == Schema Information
# Schema version: 20120217190417
#
# Table name: testimonials
#
#  id                 :integer         not null, primary key
#  person             :string(255)
#  quote              :text
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  position           :integer
#  page               :string(255)
#

class Testimonial < ActiveRecord::Base

  has_attached_file :photo,
                    :storage        => :s3,
                    :s3_credentials => "#{Rails.root}/config/environments/#{Rails.env}/amazon_s3.yml",
                    :path           => "#{Rails.env}/testimonial_photos/:id/:style/:filename",
                    :bucket         => "spoonfeed",
                    :url            => ':s3_domain_url',
                    :default_url    => "/images/default_avatars/small.png",
                    :styles         => { :small => "114x114>" }

  validates_attachment_content_type :photo,
      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/pjpeg", "image/x-png"],
      :message => "Please upload a valid image type: jpeg, gif, or png", :if => :photo_file_name

  validates_presence_of :person, :quote, :photo, :page

  scope :by_position, :order => :position
  scope :for_page, lambda { |page|
    { :conditions => { :page => page } }
  }
  
  attr_accessible :photo,:quote,:person,:page

  def self.page_options
    ["RIA HQ", "Spoonfeed"]
  end

end
