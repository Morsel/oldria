require_relative '../spec_helper'

describe PdfRemoteAttachment do
it { should validate_attachment_content_type(:attachment).
                allowing("application/zip", "application/x-zip", "application/x-zip-compressed", "application/pdf", "application/x-pdf")}
it { should validate_presence_of(:attachment_file_name) }


  before(:each) do
    @valid_attributes = FactoryGirl.attributes_for(:pdf_remote_attachment)
  end

  it "should create a new instance given valid attributes" do
    PdfRemoteAttachment.create!(@valid_attributes)
  end
end 

