# == Schema Information
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
#

require 'spec_helper'

describe Menu do
  before(:each) do
    pdf_remote_attachment = PDFRemoteAttachment.create!(:attachment_content_type => "application/pdf")
    @valid_attributes = {
      :name => "value for name",
      :change_frequency => "Monthly",
      :pdf_remote_attachment => pdf_remote_attachment,
      :restaurant_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Menu.create!(@valid_attributes)
  end

  describe "validations" do
    describe "change_frequency" do
      it "fails if change_frequency is not one of the allowed values" do
        attributes = @valid_attributes.merge(:change_frequency => "Once a Decade")
        menu = Menu.new(attributes)
        result = menu.save
        result.should be_false
      end
    end
  end
end

