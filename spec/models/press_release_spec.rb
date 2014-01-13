require_relative '../spec_helper'

describe PressRelease do
  it { should belong_to(:pdf_remote_attachment) }
  it { should belong_to(:restaurant) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:pdf_remote_attachment) }
  it { should accept_nested_attributes_for(:pdf_remote_attachment) }

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
