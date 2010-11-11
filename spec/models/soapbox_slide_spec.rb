# == Schema Information
#
# Table name: soapbox_slides
#
#  id                 :integer         not null, primary key
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :integer
#  title              :string(255)
#  excerpt            :text
#  link               :string(255)
#  position           :integer
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe SoapboxSlide do
  before(:each) do
    @valid_attributes = Factory.attributes_for(:soapbox_slide)
  end

  it "should create a new instance given valid attributes" do
    SoapboxSlide.create!(@valid_attributes)
  end
end
