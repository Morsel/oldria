require_relative '../spec_helper'

describe PressRelease do
  before(:each) do
    pdf_remote_attachment = PdfRemoteAttachment.create!(:attachment_content_type => "application/pdf", :attachment_file_name => "my_file.pdf")
    @valid_attributes = {
      :title => "value for title",
      :pdf_remote_attachment => pdf_remote_attachment,
      :restaurant_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    PressRelease.create!(@valid_attributes)
  end
end
